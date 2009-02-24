Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:55436 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbZBXNXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 08:23:54 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2478608rvb.1
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 05:23:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902241416080.4494@axis700.grange>
References: <ur61pd8h5.wl%morimoto.kuninori@renesas.com>
	 <Pine.LNX.4.64.0902241416080.4494@axis700.grange>
Date: Tue, 24 Feb 2009 22:23:52 +0900
Message-ID: <aec7e5c30902240523u6416bd9fo5470cdb1218e63f9@mail.gmail.com>
Subject: Re: About the specific setting for lens
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: morimoto.kuninori@renesas.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 24, 2009 at 10:17 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 23 Feb 2009, morimoto.kuninori@renesas.com wrote:
>
>>
>> Dear Guennadi.
>>
>> Now MigoR and AP325 board have ov772x camera.
>> However, the lens used is different.
>>
>> And I have a specific good setting value
>> for the lens of AP325.
>>
>> So, I would like to add new function for
>> specific lens value.
>> meybe like this.
>> Can I add it ?
>>
>> -- board-ap325 ---------------
>> static const struct regval_list ov772x_lens[] = {
>>        { 0xAA, 0xBB }, { 0xCC, 0xDD }, { 0xEE, 0xFF },
>>        ...
>>        ENDMARKER,
>> }
>>
>> static struct ov772x_camera_info ov772x_info = {
>>        ...
>>        .lenssetting = ov772x_lens,
>> }
>
> Hm, lenses can be replaced in principle, right? Does it really make sense
> to hard-code them in platform code? Maybe better as module parameter? Or
> are these parameters really board-specific?

I'd say that having such information with the platform data is as good
as it gets. =) In theory it's possible to replace the lens - it's
actually possible to remove the ap325 camera module as well. Using a
module parameter doesn't really make it any better since the same
driver may be used by multiple instances with different lens setups.
At least platform data makes the configuration per-camera instead of
per-driver.

Cheers,

/ magnus
