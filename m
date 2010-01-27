Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:32951 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0A0NOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 08:14:18 -0500
Received: by ewy19 with SMTP id 19so425539ewy.21
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 05:14:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100126193726.00bcbc00@tele>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br>
	 <20100126193726.00bcbc00@tele>
Date: Wed, 27 Jan 2010 10:14:16 -0300
Message-ID: <c2fe070d1001270514n69d1c159o76e3be84ef2a8dab@mail.gmail.com>
Subject: Re: Setting up the exposure time of a webcam
From: leandro Costantino <lcostantino@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Nicolau....
remember to send a SOB if the patch is working, and any change let me
know so i can test with others t613 users.
Best Regards

On Tue, Jan 26, 2010 at 3:37 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Tue, 26 Jan 2010 15:00:53 -0200
> Nicolau Werneck <nwerneck@gmail.com> wrote:
>
>> Hello. I have this very cheap webcam that I sent a patch to support on
>> gspca the other day. The specific driver is the t613.
>>
>> I changed the lens of this camera, and now my images are all too
>> bright, what I believe is due to the much larger aperture of this new
>> lens. So I would like to try setting up a smaller exposure time on the
>> camera (I would like to do that for other reasons too).
>>
>> The problem is there's no "exposure" option to be set when I call
>> programs such as v4lctl. Does that mean there is definitely no way for
>> me to control the exposure time? The hardware itself was not designed
>> to allow me do that? Or is there still a chance I can create some C
>> program that might do it, for example?
>        [snip]
>
> Hello Nicolau,
>
> There are brightness, contrast, colors, autogain and some other video
> controls for the t613 webcams. You must use a v4l2 compliant program to
> change them, as vlc or v4l2ucp (but not cheese).
>
> Regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
