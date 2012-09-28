Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34162 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab2I1SpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 14:45:20 -0400
Received: by bkcjk13 with SMTP id jk13so3820992bkc.19
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 11:45:19 -0700 (PDT)
Message-ID: <5065F03C.4000509@gmail.com>
Date: Fri, 28 Sep 2012 20:45:16 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Albert Wang <twang13@marvell.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support
 on marvell-ccic mcam-core
References: <1348840040-21390-1-git-send-email-twang13@marvell.com> <201209281615.49420.hverkuil@xs4all.nl> <477F20668A386D41ADCC57781B1F7043083B590CA2@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083B590CA2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/28/2012 08:37 PM, Albert Wang wrote:
>>> +	ret = v4l2_subdev_call(sd, core, g_chip_ident,&id);
> 
>> Yuck. Don't abuse this. g_chip_ident is for debugging purposes only.
> 
> Yes, can remove it.
> 
>>> +	if (ret<  0) {
>>> +		cam_err(mcam, "%s %d\n", __func__, __LINE__);
>>> +		return ret;
>>> +	}
>>> +
>>> +	strcpy(cap->card, mcam->card_name);
>>> +	strncpy(cap->driver, (const char *)&(id.ident), 4);
> 
>> No, the name of the driver is the name of this module: marvell_ccic.
>> It's *not* the name of the sensor driver.
> 
> Yes, maybe you are right, we misunderstood this usage.
> 
> But I'm confused with how can we put the sensor module name to upper level?
> I mean upper level user want to know which sensor module is connecting to the controller.
> Currently, our user get the sensor module name by call this ioctl VIDIOC_QUERYCAP.
> 
> Anyway, maybe we need change the usage model.

Is there anything preventing you from using VIDIOC_ENUM_INPUT/VIDIOC_G_INPUT
ioctls for that ?

--

Regards,
Sylwester
