Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38785 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2DRSUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 14:20:23 -0400
Received: by qcro28 with SMTP id o28so4699295qcr.19
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 11:20:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F8EFD7B.2020901@iki.fi>
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
	<4F804CDC.3030306@gmail.com>
	<CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com>
	<4F85D787.2050403@iki.fi>
	<4F85F89A.80107@schinagl.nl>
	<4F85FE63.1030700@iki.fi>
	<4F86C66A.4010404@schinagl.nl>
	<CAKZ=SG8gHbnRGFrajp2=Op7x52UcMT_5CFM5wzgajKCXkggFtA@mail.gmail.com>
	<4F86CE09.3080601@schinagl.nl>
	<CAKZ=SG95OA3pOvxM6eypsNaBvzX1wfjPR4tucc8725bnhE3FEg@mail.gmail.com>
	<4F86D4B8.8060005@iki.fi>
	<CAKZ=SG8G8w1J_AF-bOCn2n8gcEogGPQ1rmp45wCtmwFgOUPifA@mail.gmail.com>
	<4F8EFD7B.2020901@iki.fi>
Date: Wed, 18 Apr 2012 20:20:22 +0200
Message-ID: <CAKZ=SG8=z6c4-n8wkMK1YmTzWs9rN9JrbM907+K+X0k4ampSJA@mail.gmail.com>
Subject: Re: RTL28XX driver
From: Thomas Mair <thomas.mair86@googlemail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't know what it really is either but the comments are the following.

if (frequency > 300000000)
{
				
	printk("  %s : Tuner :FC0012 V-band (GPIO6 high)\n", __FUNCTION__);		
}
else
{
	printk("  %s : Tuner :FC0012 U-band (GPIO6 low)\n", __FUNCTION__);	
}

I looked into both mechanisms but can't really decide which one would
be the best one for this. What is the correct ioctl constant to listen
for or do I define an own constant? And how is the ioctl command
issued within the demod driver?

Thomas

2012/4/18 Antti Palosaari <crope@iki.fi>:
> On 18.04.2012 20:18, Thomas Mair wrote:
>>
>> I have been working on the driver over the past days and been making
>> some progress. Right now I am stuck with a small problem that I have
>> no idea how to deal with.
>>
>> It seems that the fc0012 tuner supports V-Band and U-Band. To switch
>> between those modes a GPIO output value needs to be changed. In the
>> original Realtek driver this is done at the beginning of the
>> set_parameters callback. Is there a different callback that can be
>> used for this or is it ok to write a RTL2832u register from the
>> demodulator code?
>
>
> Aah, I suspect it is antenna switch or LNA GPIO. You don't say what is
> meaning of that GPIO...
> If it is FC0012 input, which I think it is not, then you should use FE
> callback (named as callback too) with  DVB_FRONTEND_COMPONENT_TUNER param.
> But I suspect it is not issue.
>
> So lets introduce another solution. It is fe_ioctl_override. Use it.
>
> You will find good examples both cases using following GIT greps
> git grep fe_ioctl_override drivers/media
> git grep FRONTEND_COMPONENT
>
> Antti
> --
> http://palosaari.fi/
