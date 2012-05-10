Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33723 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2EJPan (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 11:30:43 -0400
Received: by yenm10 with SMTP id m10so1590861yen.19
        for <linux-media@vger.kernel.org>; Thu, 10 May 2012 08:30:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336662597.15542.15.camel@iivanov-desktop>
References: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com>
	<CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com>
	<1336662597.15542.15.camel@iivanov-desktop>
Date: Thu, 10 May 2012 10:30:37 -0500
Message-ID: <CAC-OdnAnhN8stgaUVM06GGf79Lzx8cKGK9Xwxx8VhqFwJ=RU=A@mail.gmail.com>
Subject: Re: Advice on extending libv4l for media controller support
From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Atsuo Kuwahara <kuwahara@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivan,

Great to hear from you! Long time :)

On Thu, May 10, 2012 at 10:09 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>
> Hi Sergio,
>
> On Thu, 2012-05-10 at 08:54 -0500, Sergio Aguirre wrote:
>> +Atsuo
>>
>> On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre
>> <sergio.a.aguirre@gmail.com> wrote:
>> > Hi Hans,
>> >
>> > I'm interested in using libv4l along with my omap4 camera project to
>> > adapt it more easily
>> > to Android CameraHAL, and other applications, to reduce complexity of
>> > them mostly...
>> >
>> > So, but the difference is that, this is a media controller device I'm
>> > trying to add support for,
>> > in which I want to create some sort of plugin with specific media
>> > controller configurations,
>> > to avoid userspace to worry about component names and specific
>> > usecases (use sensor resizer, or SoC ISP resizer, etc.).
>> >
>> > So, I just wanted to know your advice on some things before I start
>> > hacking your library:
>> >
>
> Probably following links can help you. They have been tested
> with the OMAP3 ISP.

Awesome! This is certainly very useful. I'll look into adding OMAP4
ISS support too.

Thanks for sharing!

Regards,
Sergio

>
> Regards,
> iivanov
>
> [1] http://www.spinics.net/lists/linux-media/msg31901.html
> [2]
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32704
>
>
