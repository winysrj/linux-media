Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:33596 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754968AbeDTO3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 10:29:45 -0400
Subject: Re: [PATCH 2/3] media: ov5640: add PIXEL_RATE and LINK_FREQ controls
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-2-daniel@zonque.org>
 <20180420141528.ethp34p6czomokpi@flea>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <5d51bdb7-936a-3a6c-bc6d-168cd5221e4d@zonque.org>
Date: Fri, 20 Apr 2018 16:29:42 +0200
MIME-Version: 1.0
In-Reply-To: <20180420141528.ethp34p6czomokpi@flea>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday, April 20, 2018 04:15 PM, Maxime Ripard wrote:
> On Fri, Apr 20, 2018 at 11:44:18AM +0200, Daniel Mack wrote:

>>  struct ov5640_ctrls {
>>  	struct v4l2_ctrl_handler handler;
>> +	struct {
>> +		struct v4l2_ctrl *link_freq;
>> +		struct v4l2_ctrl *pixel_rate;
>> +	};
>>  	struct {
>>  		struct v4l2_ctrl *auto_exp;
>>  		struct v4l2_ctrl *exposure;
>> @@ -732,6 +752,8 @@ static const struct ov5640_mode_info ov5640_mode_init_data = {
>>  	.dn_mode	= SUBSAMPLING,
>>  	.width		= 640,
>>  	.height		= 480,
>> +	.pixel_rate	= 27766666,
>> +	.link_freq_idx	= OV5640_LINK_FREQ_111,
> 
> I'm not sure where this is coming from, but on a parallel sensor I
> have a quite different pixel rate.

Ah, interesting. What exactly do you mean by 'parallel'? What kind of
module is that, and what are your pixel rates?

> I have a serie ongoing that tries to deal with this, hopefully in
> order to get rid of all the clock setup done in the initialiasation
> array.
> 
> See https://patchwork.linuxtv.org/patch/48710/ for the patch and
> https://www.spinics.net/lists/linux-media/msg132201.html for a
> discussion on what the clock tree might look like on a MIPI-CSI bus.

Okay, nice. Even better if this patch isn't needed in the end.


Thanks!
Daniel
