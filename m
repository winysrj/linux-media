Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:36906 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756475Ab0DNSj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 14:39:58 -0400
Message-ID: <4BC60BF5.5090901@yahoo.it>
Date: Wed, 14 Apr 2010 20:39:49 +0200
From: Adriano Gigante <adrigiga@yahoo.it>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Florent NOUVELLON <flonouvellon@gmail.com>,
	fogna <fogna80@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Info
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com> 	<ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com> 	<829197381001180716v59b84ee2ia8ca2d9be4be5b22@mail.gmail.com> 	<4B54864E.1050801@yahoo.it> <829197381001180817r561bb1cdj9edda6ab3affbba0@mail.gmail.com> 	<d9def9db1001180829n733471c6g375295f29fc349ea@mail.gmail.com> 	<829197381001180836ybc4a4c6l6cf1c2bbabdf96b8@mail.gmail.com> 	<d9def9db1001180933x3fc31353g87cd06312a57cbf1@mail.gmail.com> 	<4B54AD5B.7040305@gmail.com> <d9def9db1001181105i7eac4a0ct3b8845b0f2904e38@mail.gmail.com> <664add071002140933h777f6bd2j649dd6a91e0448c7@mail.gmail.com>
In-Reply-To: <664add071002140933h777f6bd2j649dd6a91e0448c7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

...do you think we will have our stick (0072/terratec hybrid xs fm) 
working before FIFA World Cup?


Thanks
Adriano


Il 14/02/2010 18:33, Florent NOUVELLON ha scritto:
> Hi Devin,
>
> Did you with Prahal advanced the 0072/terratec hybrid xs fm support in
> linux-dvb driver ?
>
> If you need any kind of help (testing, or whatever) feel free to ask me.
>
> Regards,
> Florent
>
>
> 2010/1/18 Markus Rechberger <mrechberger@gmail.com
> <mailto:mrechberger@gmail.com>>
>
>     On Mon, Jan 18, 2010 at 7:50 PM, fogna <fogna80@gmail.com
>     <mailto:fogna80@gmail.com>> wrote:
>      > Il 01/18/2010 06:33 PM, Markus Rechberger ha scritto:
>      >> On Mon, Jan 18, 2010 at 5:36 PM, Devin Heitmueller
>      >> <dheitmueller@kernellabs.com
>     <mailto:dheitmueller@kernellabs.com>> wrote:
>      >>
>      >>> Hello Markus,
>      >>>
>      >>> On Mon, Jan 18, 2010 at 11:29 AM, Markus Rechberger
>      >>> <mrechberger@gmail.com <mailto:mrechberger@gmail.com>> wrote:
>      >>>
>      >>>> Just fyi there's a hardware bug with the 0072/terratec hybrid
>     xs fm
>      >>>> (cx25843 - xc5000):
>      >>>>
>      >>>> http://img91.imageshack.us/i/00000004qf8.png/
>      >>>> http://img104.imageshack.us/i/00000009cp4.png/
>      >>>>
>      >>>> nothing that can be fixed with the driver.
>      >>>>
>      >>> Interesting.  If it cannot be fixed with the driver, how does the
>      >>> Windows driver work then?  Is this some sort of premature hardware
>      >>> failure that occurs (after which point it is irreversible)?
>      >>>
>      >>>
>      >> conexant cx25843 - xceive xc5000 failure (as what I've heard
>     conexant
>      >> laid off people in that area years ago while xceive (see their
>     driver
>      >> changelog if you have access to it) tried to fix it with their
>      >> firmware but didn't succeed), it also happens with windows. Those
>      >> screenshots are taken from a videoclip
>      >> it was of course a big problem for business customers (almost all of
>      >> them happily switched away from it)
>      >> This is the same retail hardware as everyone else uses out there. XS
>      >> FM is not being sold anymore.
>      >> I only know one company in Ireland still

ing with it, also in
>      >> terms of videoquality I'd avoid that combination.
>      >>
>      >> Markus
>      >>
>      >>
>      >>> Thanks for taking the time to point this out though, since I could
>      >>> totally imagine banging my head against the wall for quite a while
>      >>> once I saw this.
>      >>>
>      >>> Devin
>      >>>
>      >>> --
>      >>> Devin J. Heitmueller - Kernel Labs
>      >>> http://www.kernellabs.com
>      >>>
>      >>>
>      >> --
>      >> To unsubscribe from this list: send the line "unsubscribe
>     linux-media" in
>      >> the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>      >> More majordomo info at http://vger.kernel.org/majordomo-info.html
>      >>
>      >>
>      > Hi Markus, thanks for the info, i didn't know of this hardware
>     problem,
>      > i have this usb stick and at the moment all works normally, now i
>     know
>      > when it will be time to replace it :)
>      >
>
>     it happens sporadically sometimes 1 time/5 minutes sometimes 1
>     time/10 minutes.
>     I think in windows it sometimes drops frames it also happens there and
>     can be seen with VLC
>     maybe some codecs also compensate it a little bit. There's no generic
>     rule about this the xc5000
>     overdrives the videodecoder (it's not empia related issue actually
>     moreover conexant/xceive)
>
>     Markus
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-media" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>

