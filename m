Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KqFXq-00061U-Be
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 01:12:48 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1488233nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 16:12:40 -0700 (PDT)
Message-ID: <37219a840810151612g7345eab6t9290273e750338fd@mail.gmail.com>
Date: Wed, 15 Oct 2008 19:12:40 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48F671E0.6080002@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <E3C12FE3-4050-4C71-9CC5-CB67A67DA6C8@receptiveit.com.au>
	<48F671E0.6080002@linuxtv.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Dvico HDTV Dual Express
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

On Wed, Oct 15, 2008 at 6:42 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Alex Ferrara wrote:
>> As reported by an earlier email, I have had poor tuner results with my
>> dual express card. I have tried playing with the RF amplification,
>> removing it completely, and testing the card in the same environment
>> running Vista. Vista works great, Linux does not.
>
> This card works perfectly for me, I use it all of the time under Linux.

Steve, you have the FusionHDTV 7 Dual Express, which is *not* the
FusionHDTV Dual Digital 4.

Alex,  if you search the mailing lists, you will find various other
user reports of poor tuning performance with various revisions of the
Dual Digital 4.

You say that you have version 2 -- can you check which IC's are on the
device?  IIRC, that should be a Cypress FX2 with two dib7070's

...If you have 2 xc3028's (or xc3008's) and two zl10353's (or mt352's)
then its rev 1.  I haven't heard users reporting problems with the
dib7070 version -- maybe some tweaking is needed.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
