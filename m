Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55771 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757782AbdELKAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 06:00:40 -0400
Subject: Re: [PATCH] [media] cec: improve MEDIA_CEC_RC dependencies
To: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170421105224.899350-1-arnd@arndb.de>
 <CAK8P3a2V4mUtPNWnFXBBNABqt09vRujRE1w=6wkYc1q63-Ujhg@mail.gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <632c9564-97f3-7e43-11a5-222ba835889d@xs4all.nl>
Date: Fri, 12 May 2017 12:00:30 +0200
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2V4mUtPNWnFXBBNABqt09vRujRE1w=6wkYc1q63-Ujhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/17 11:49, Arnd Bergmann wrote:
> On Fri, Apr 21, 2017 at 12:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Changing the IS_REACHABLE() into a plain #ifdef broke the case of
>> CONFIG_MEDIA_RC=m && CONFIG_MEDIA_CEC=y:
>>
>> drivers/media/cec/cec-core.o: In function `cec_unregister_adapter':
>> cec-core.c:(.text.cec_unregister_adapter+0x18): undefined reference to `rc_unregister_device'
>> drivers/media/cec/cec-core.o: In function `cec_delete_adapter':
>> cec-core.c:(.text.cec_delete_adapter+0x54): undefined reference to `rc_free_device'
>> drivers/media/cec/cec-core.o: In function `cec_register_adapter':
>> cec-core.c:(.text.cec_register_adapter+0x94): undefined reference to `rc_register_device'
>> cec-core.c:(.text.cec_register_adapter+0xa4): undefined reference to `rc_free_device'
>> cec-core.c:(.text.cec_register_adapter+0x110): undefined reference to `rc_unregister_device'
>> drivers/media/cec/cec-core.o: In function `cec_allocate_adapter':
>> cec-core.c:(.text.cec_allocate_adapter+0x234): undefined reference to `rc_allocate_device'
>> drivers/media/cec/cec-adap.o: In function `cec_received_msg':
>> cec-adap.c:(.text.cec_received_msg+0x734): undefined reference to `rc_keydown'
>> cec-adap.c:(.text.cec_received_msg+0x768): undefined reference to `rc_keyup'
>>
>> This adds an additional dependency to explicitly forbid this combination.
>>
>> Fixes: 5f2c467c54f5 ("[media] cec: add MEDIA_CEC_RC config option")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
> 
> What is the status of this patch? According to
> https://patchwork.linuxtv.org/patch/40934/ it is marked 'accepted',
> but the patch that caused the problem has made it into mainline
> in the merge window, and the fix is still needed on top.

It's in a pull request for 4.12 that Mauro hasn't picked up yet. I
pinged him, but he seems to be very busy lately.

> 
> On a related note, I've run into another link error now:
> 
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_remove':
> sti_hdmi.c:(.text.sti_hdmi_remove+0x10): undefined reference to
> `cec_notifier_set_phys_addr'
> sti_hdmi.c:(.text.sti_hdmi_remove+0x34): undefined reference to
> `cec_notifier_put'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_get_modes':
> sti_hdmi.c:(.text.sti_hdmi_connector_get_modes+0x4a): undefined
> reference to `cec_notifier_set_phys_addr_from_edid'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_probe':
> sti_hdmi.c:(.text.sti_hdmi_probe+0x204): undefined reference to
> `cec_notifier_get'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_detect':
> sti_hdmi.c:(.text.sti_hdmi_connector_detect+0x36): undefined reference
> to `cec_notifier_set_phys_addr'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_disable':
> sti_hdmi.c:(.text.sti_hdmi_disable+0xc0): undefined reference to
> `cec_notifier_set_phys_addr'
> 
> The config options leading to the second failure are:
> 
> CONFIG_MEDIA_CEC_SUPPORT=y
> CONFIG_CEC_CORE=m
> CONFIG_MEDIA_CEC_NOTIFIER=y
> CONFIG_VIDEO_STI_HDMI_CEC=m
> CONFIG_DRM_STI=y
> 
> I can probably come up with a workaround, but haven't completely thought
> through all the combinations yet. Also, I assume the same fix will be needed
> for exynos, though that has not come up in randconfig testing so far.

Try this patch:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index eb50ce54b759..da3528c8edb9 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -29,7 +29,7 @@ struct edid;
 struct cec_adapter;
 struct cec_notifier;

-#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+#if IS_REACHABLE(CONFIG_MEDIA_CEC_NOTIFIER)

 /**
  * cec_notifier_get - find or create a new cec_notifier for the given device.
