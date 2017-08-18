Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35842 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750969AbdHRKOB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 06:14:01 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
 <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
Date: Fri, 18 Aug 2017 12:13:55 +0200
MIME-Version: 1.0
In-Reply-To: <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/17 11:02, Tomi Valkeinen wrote:
> Hi Hans,
> 
> 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> 
> On 11/08/17 13:57, Tomi Valkeinen wrote:
> 
>> I'm doing some testing with this series on my panda. One issue I see is
>> that when I unload the display modules, I get:
>>
>> [   75.180206] platform 58006000.encoder: enabled after unload, idling
>> [   75.187896] platform 58001000.dispc: enabled after unload, idling
>> [   75.198242] platform 58000000.dss: enabled after unload, idling
> 
> This one is caused by hdmi_cec_adap_enable() never getting called with
> enable=false when unloading the modules. Should that be called
> explicitly in hdmi4_cec_uninit, or is the CEC framework supposed to call it?

Nicely found!

The cec_delete_adapter() function calls __cec_s_phys_addr(CEC_PHYS_ADDR_INVALID)
which would normally call adap_enable(false), except when the device node was
already unregistered, in which case it just returns immediately.

The patch below should fix this. Let me know if it works, and I'll post a proper
patch and get that in for 4.14 (and possible backported as well, I'll have to
look at that).

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bf45977b2823..61dffe165565 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1390,7 +1390,9 @@ static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
  */
 void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 {
-	if (phys_addr == adap->phys_addr || adap->devnode.unregistered)
+	if (phys_addr == adap->phys_addr)
+		return;
+	if (phys_addr != CEC_PHYS_ADDR_INVALID && adap->devnode.unregistered)
 		return;

 	dprintk(1, "new physical address %x.%x.%x.%x\n",
