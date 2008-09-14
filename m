Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Keyhr-0007OC-4o
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 23:00:33 +0200
Received: by wx-out-0506.google.com with SMTP id t16so712891wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 14:00:24 -0700 (PDT)
Message-ID: <d9def9db0809141400m31dbd30cl5eea698e63cd1de5@mail.gmail.com>
Date: Sun, 14 Sep 2008 23:00:23 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Simon Kenyon" <simon@koala.ie>
In-Reply-To: <1221425655.10386.4.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<48CC42D8.8080806@gmail.com> <1221419319.9803.0.camel@localhost>
	<d9def9db0809141225q421828cdn8b97c0e61b99acac@mail.gmail.com>
	<1221425655.10386.4.camel@localhost>
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

On Sun, Sep 14, 2008 at 10:54 PM, Simon Kenyon <simon@koala.ie> wrote:
> On Sun, 2008-09-14 at 21:25 +0200, Markus Rechberger wrote:
>> On Sun, Sep 14, 2008 at 9:08 PM, Simon Kenyon <simon@koala.ie> wrote:
>> > On Sun, 2008-09-14 at 02:46 +0400, Manu Abraham wrote:
>> >> The initial set of DVB-S2 multistandard devices supported by the
>> >> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>> >> alone. There are more additions by 2 more modules (not devices), but for
>> >> the simple comparison here is the quick list of them, for which some of
>> >> the manufacturers have shown support in some way. (There has been quite
>> >> some contributions from the community as well.):
>> >>
>> >> (Also to be noted is that, some BSD chaps also have shown interest in
>> >> the same)
>> >
>> > is there any issue with GPL code being merged into BSD?
>> > just asking
>>
>> Not with the code which comes from our side. They're at DVB-T right
>> now which already works.
>> That code is fully duallicensed.
>> The Bridge code itself needs to get slightly refactored for analog TV.
>> They are getting full technical and HW support.
>
> not quite sure (in the context of your sentence) who "our side" is.
> all the code on mcentral.de seems to be GPL 2 or greater with copyright
> claimed by you and others. i've seen nothing on this mailing list about
> dual licencing any linuxtv.org code.
>
> i am in no way a gpl bigot. but legal niceties have to be dealt with.


It's on the website, especially the new drivers which came from Empia
are dual licensed
and intended to be reused with other systems. GPL is just the one
which is used with Linux.

Those parts which are in question in case of license violations will
be replaced and pointed out to people
who port the code. No big deal.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
