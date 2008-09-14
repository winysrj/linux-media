Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KexDd-0007hx-7w
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 21:25:14 +0200
Received: by yx-out-2324.google.com with SMTP id 8so499186yxg.41
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 12:25:09 -0700 (PDT)
Message-ID: <d9def9db0809141225q421828cdn8b97c0e61b99acac@mail.gmail.com>
Date: Sun, 14 Sep 2008 21:25:08 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Simon Kenyon" <simon@koala.ie>
In-Reply-To: <1221419319.9803.0.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<48CC42D8.8080806@gmail.com> <1221419319.9803.0.camel@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Sun, Sep 14, 2008 at 9:08 PM, Simon Kenyon <simon@koala.ie> wrote:
> On Sun, 2008-09-14 at 02:46 +0400, Manu Abraham wrote:
>> The initial set of DVB-S2 multistandard devices supported by the
>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>> alone. There are more additions by 2 more modules (not devices), but for
>> the simple comparison here is the quick list of them, for which some of
>> the manufacturers have shown support in some way. (There has been quite
>> some contributions from the community as well.):
>>
>> (Also to be noted is that, some BSD chaps also have shown interest in
>> the same)
>
> is there any issue with GPL code being merged into BSD?
> just asking

Not with the code which comes from our side. They're at DVB-T right
now which already works.
That code is fully duallicensed.
The Bridge code itself needs to get slightly refactored for analog TV.
They are getting full technical and HW support.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
