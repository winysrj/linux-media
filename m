Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web53210.mail.re2.yahoo.com ([206.190.49.80])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <deloptes@yahoo.com>) id 1K4z6I-0003i1-Ot
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 16:09:02 +0200
Date: Sat, 7 Jun 2008 07:08:23 -0700 (PDT)
From: Emanoil Kotsev <deloptes@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <200806071348.01159.christophpfister@gmail.com>
MIME-Version: 1.0
Message-ID: <958689.73756.qm@web53210.mail.re2.yahoo.com>
Subject: Re: [linux-dvb] Fwd: wrong dvb-t channel information in file
	"dvb-t/at-Official"
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

Hi,

I've got the same issue and found the channels in the
Bavarian broadcast file. I think I wrote to the list
then.

regards

--- Christoph Pfister <christophpfister@gmail.com>
wrote:

> From a kaffeine user ...
> 
> Christoph
> 
> 
> ----------  Weitergeleitete Nachricht  ----------
> 
> Betreff: [Bug 163374] New: wrong dvb-t channel
> information in 
> file "dvb-t/at-Official"
> Datum: Freitag 06 Juni 2008
> Von: Daniel Blaschke <e9825797@stud3.tuwien.ac.at>
> An: christophpfister@gmail.com
> 
> ------- You are receiving this mail because: -------
> You are the assignee for the bug, or are watching
> the assignee.
>          
> http://bugs.kde.org/show_bug.cgi?id=163374         
>            Summary: wrong dvb-t channel information
> in file "dvb-t/at-
>                     Official"
>            Product: kaffeine
>            Version: unspecified
>           Platform: Debian testing
>         OS/Version: Linux
>             Status: UNCONFIRMED
>           Severity: normal
>           Priority: NOR
>          Component: general
>         AssignedTo: hftom free fr
>         ReportedBy: e9825797 stud3 tuwien ac at
> 
> 
> Version:           0.8.6 (using KDE 3.5.9)
> Installed from:    Debian testing/unstable Packages
> OS:                Linux
> 
> In the file "dvb-t/at-Official" please change the
> line #14 from
> 
> T 578000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE
> 
> to
> 
> T 578000000 8MHz 3/4 NONE QAM16 8k 1/8 NONE
> 
> (1/8 instead of 1/4) since the channels transmitted
> in Vienna on that 
> frequency (3SAT, Puls 4 and ORF Sport Plus) are not
> detected by kaffeine 
> otherwise.
> 
> The line #6 with frequency 498000000 (ORF 1&2 and
> ATV) is correct with 
> the "1/4". I live in Vienna and therefore haven't
> had the chance to check the 
> other frequencies, i.e. those two are the only ones
> I get.
> 
> cheers, Daniel
> 
>
-------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
>
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 





      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
