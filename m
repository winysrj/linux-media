Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JfICB-0006BO-W8
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 18:16:52 +0100
Received: by nf-out-0910.google.com with SMTP id d21so183620nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 10:16:17 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: Arthur Konovalov <kasjas@hot.ee>
Date: Fri, 28 Mar 2008 18:16:10 +0100
References: <200803212024.17198.christophpfister@gmail.com>
	<200803281535.57209.christophpfister@gmail.com>
	<47ED0962.20701@hot.ee>
In-Reply-To: <47ED0962.20701@hot.ee>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803281816.10525.christophpfister@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Freitag 28 M=E4rz 2008 schrieb Arthur Konovalov:
> Christoph Pfister wrote:
> > But scrambled channels don't work without those patches either, right?
>
> Yes, You are right. Only black screen in xine.
>
> > Paste the strace output of vdr or try kaffeine ...
>
> vdr strace log attached.
>
> Regards,
> Arthur

Try removing the following three lines from =

linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c and see whether it works:

989 				/* clear down an old CI slot if necessary */
990 				if (ca->slot_info[slot].slot_state !=3D DVB_CA_SLOTSTATE_NONE)
991 					dvb_ca_en50221_slot_shutdown(ca, slot);

If it doesn't work load budget-core with module param debug=3D255 and dvb-c=
ore =

with module param cam_debug=3D1 (likely you need to unload them first); ple=
ase =

paste dmesg in any case.

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
