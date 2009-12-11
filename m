Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:58901 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZLKUns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 15:43:48 -0500
Received: by ewy1 with SMTP id 1so1560595ewy.28
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 12:43:54 -0800 (PST)
From: Antonio Marcos =?iso-8859-1?q?L=F3pez_Alonso?=
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Subject: [SOLVED] dib0700: Nova-T-500 remote - mixed button codes
Date: Fri, 11 Dec 2009 20:43:48 +0000
References: <200912111509.51455.amlopezalonso@gmail.com> <CFDDDF371FF6814E9445C4C937125CE6027007F3C6@CROP3MMBX03.mail.aig.net>
In-Reply-To: <CFDDDF371FF6814E9445C4C937125CE6027007F3C6@CROP3MMBX03.mail.aig.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912112043.48541.amlopezalonso@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spot on, Christophe!

I didn't realize I have not tried swapping the sensor wires and this little 
damned thing is working now!

However I must point the "faulty" sensor wire works right with the HVR-1100. I 
cannot tell which sensor belongs to which card (both of them are identical 
except the "working" Nova-T-500 wire that shows a label with what seems to be 
a P/N or a S/N on it) so I suppose the Nova-T-500 wire works well with the 
HVR-1100 but not the opposite (maybe a bandwidth issue). To support this 
theory there is the fact that the spurious keycodes are not random but always 
the same per remote button (but the happening frequency is random indeed).

Thanks a lot for your help!

Antonio



El Viernes 11 Diciembre 2009, Rochet, Christophe escribió:
> Hi Antonio.
> 
> Did you switched also the IR remote sensor itself ?
> 
> I experienced same weird things with a WinovaTV years ago, and finally the
>  IR phototransistor in the small round receiver was crappy. When I changed
>  it by a common spare it all came right.
> 
> Protect also your IR sensor from AC lights...
> 
> If you experiment "random" keys, a noisy IR signal or dead receiver is
>  perhaps the cause.
> 
> If you experiment always the same button jam, that's something else.
> 
> Regards.
> 
> -----Message d'origine-----
> De : linux-media-owner@vger.kernel.org
>  [mailto:linux-media-owner@vger.kernel.org] De la part de Antonio Marcos
>  López Alonso Envoyé : vendredi 11 décembre 2009 16:10
> À : linux-media@vger.kernel.org
> Objet : dib0700: Nova-T-500 remote - mixed button codes
> 
> Hi all,
> 
> I own a Hauppauge Nova-T-500 in a box running Mythbuntu 9.10. The card runs
> fine except when it comes to the in-built remote sensor:
> 
> Whenever I press any button, the remote sensor seems to receive some other
> keycodes aside the proper one (i.e. when I press Volume Up button the
>  sensor receives it most of the time, but sometimes it understands some
>  other buttons are pressed like ArrowDown, Red button and so, making MythTV
>  experience very annoying). There are only three buttons that are always
>  well received with no confusion at all: "OK", "ArrowDown" and "Play". This
>  behavior occurs with two identical remotes I own (one of them belonging to
>  a WinTV HVR-1100) and another card user has reported a similar behavior
>  with its own and same remote.
> 
> I tested both remotes with the HVR-1100 and they behave perfectly, so I
>  guess this is not a remote related issue.
> 
> Though I have tried several LIRC setup files and swapped dvb_usb_dib0700
> firmware files (1.10 and 1.20 versions) they make no working difference at
> all.
> 
> I also tried rebuilding v4l-dvb code to no avail.
> 
> Any suggestions? I would gladly provide further info/logs upon request.
> 
> Cheers,
> Antonio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

