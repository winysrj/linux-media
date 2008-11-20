Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38801.mail.mud.yahoo.com ([209.191.125.92])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1L38Xx-0005Ca-Fj
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 13:22:11 +0100
Date: Thu, 20 Nov 2008 04:21:34 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0811201243160.6408@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Message-ID: <209003.46457.qm@web38801.mail.mud.yahoo.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH 5/5] Siano's SMS core system upgrade
Reply-To: urishk@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>




--- On Thu, 11/20/08, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:

> From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
> Subject: Re: [linux-dvb] [PATCH 5/5] Siano's SMS core system upgrade
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "Linux-dvb" <linux-dvb@linuxtv.org>
> Date: Thursday, November 20, 2008, 2:03 PM
> Hello Uri, and thanks for all the patches!
> 
> On Wed, 19 Nov 2008, Uri Shkolnik wrote:
> 
> > This patch provides the following:
> [smscore_patch.diff]
> 
> Part of this patch appears to give problems, thanks to the
> use of 8-bit characters in the original smscoreapi.h file.
> 
> This may be made worse for me by my use of UTF8 encoding
> and possibly by data getting massaged by my mailer in ways
> that I do not know about.  I haven't tried to solve
> that,
> as it would require thinking an' stuff.  Anyway:
> 
> The part of the patch which failed for me appears to be
> limited to whitespace cleanup surrounding these lines
> (cut and pasted here):
> 
> -       u8              FirmwareId; /* 0xFF ??? ROM,
> otherwise the
> -                                    * value indicated by
> -                                    *
> SMSHOSTLIB_DEVICE_MODES_E */
> 
> +       u8 FirmwareId;          /* 0xFF ??? ROM, otherwise
> the
> +                                * value indicated by
> +                                *
> SMSHOSTLIB_DEVICE_MODES_E */
> 
> The original source file which I have contains three
> bytes with 8th-bit-set where they are shown above as
> `???'.  The original file passed through `hd' gives
> 00000030  64 3b 20 2f 2a 20 30 78  46 46 20 ef bf bd 20 52 
> |d; /* 0xFF ... R|
>                                             ^^^^^^^^
> A quick google search shows this could be `U+FFFD'
> which
> is `REPLACEMENT CHARACTER' -- which means nothing to
> me,
> nor is displayed in my fonts, but it might be meaningful
> to someone else here.
> 
> Since I don't know how to preserve the intended meaning
> of the original author, I'll just suggest that if
> anyone runs into this problem and wants a quick workaround,
> to edit beforehand the original smscoreapi.h file, search
> for `ROM', and replace the above series of 8-bit or
> single
> UTF8 character(s) with the series of three ASCII `?'
> question marks, then the patch should apply.
> 
> Whereupon the above character can be restored or replaced
> with an ASCII-equivalent to preserve its original meaning.
> 
> 
> Just a FYI for anyone else.
> 
> thanks!
> barry bouwsma

Hi Barry,

Thanks for the feedback, you are absolutely right. 
Anyway, the original string is "0xFF - ROM" (just space dash space)
I'll commit a fix next week for this issue.


Thanks again,
Regards,

Uri


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
