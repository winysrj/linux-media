Return-path: <mchehab@pedra>
Received: from cnxtsmtp1.conexant.com ([198.62.9.252]:37437 "EHLO
	Cnxtsmtp1.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0JIRSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 13:18:00 -0400
Received: from cps (nbwsmx2.bbnet.ad [157.152.183.212]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by Cnxtsmtp1.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 23C01123A28 for <linux-media@vger.kernel.org>; Sat, 9 Oct 2010 10:00:36 -0700 (PDT)
From: "Sri Deevi" <Srinivasa.Deevi@conexant.com>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
cc: "linux-me >> Linux Media Mailing List" <linux-media@vger.kernel.org>
Date: Sat, 9 Oct 2010 10:00:01 -0700
Subject: RE: V4L/DVB: cx231xx: Colibri carrier offset was wrong for PAL/M
Message-ID: <34B38BE41EDBA046A4AFBB591FA311320247623BB6@NBMBX01.bbnet.ad>
References: <4CB088DA.60508@redhat.com>,<AANLkTi=gH10h5L1jpbWMUDBWbuVWRfEqVgPpzSazvMYs@mail.gmail.com>
In-Reply-To: <AANLkTi=gH10h5L1jpbWMUDBWbuVWRfEqVgPpzSazvMYs@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Good catch. OK with the fix.

Sri
________________________________________
From: Devin Heitmueller [dheitmueller@kernellabs.com]
Sent: Saturday, October 09, 2010 8:40 AM
To: Mauro Carvalho Chehab
Cc: linux-me >> Linux Media Mailing List; Sri Deevi
Subject: Re: V4L/DVB: cx231xx: Colibri carrier offset was wrong for PAL/M

On Sat, Oct 9, 2010 at 11:23 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> cx231xx: Colibri carrier offset was wrong for PAL/M
>
> The carrier offset check at cx231xx is incomplete. I got here one concrete case
> where it is broken: if PAL/M is used (and this is the default for Pixelview SBTVD),
> the routine will return zero, and the device will be programmed incorrectly,
> producing a bad image. A workaround were to change to NTSC and back to PAL/M,
> but the better is to just fix the code ;)

Thanks for spotting this.  I've been focusing entirely on NTSC, so any
such fixes for other standards are very welcome.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

