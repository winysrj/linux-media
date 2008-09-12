Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ke9Ke-0007nI-Fm
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 16:09:11 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7300C4V5Y7D2H0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 12 Sep 2008 10:08:34 -0400 (EDT)
Date: Fri, 12 Sep 2008 10:08:30 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809121529.41795.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48CA77DE.1020700@linuxtv.org>
MIME-version: 1.0
References: <48CA0355.6080903@linuxtv.org> <200809120826.31108.hftom@free.fr>
	<48CA6C2E.7050908@linuxtv.org> <200809121529.41795.hftom@free.fr>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christophe Thommeret wrote:
> Le Friday 12 September 2008 15:18:38 Steven Toth, vous avez =E9crit :
>> Christophe Thommeret wrote:
>>> Le Friday 12 September 2008 07:51:17 Steven Toth, vous avez =E9crit :
>>>> Hello!
>>>>
>>>> More progress today, 7 new patches were merged - all related to the
>>>> feedback and suggestions we had.... And a bugfix. :)
>>>>
>>>> The DTV_SET/GET command syntax has been rationalised, as Hans requeste=
d.
>>>> This cleans up the application API nicely. Various internal improvemen=
ts
>>>> and code cleanup related to variable length arrays, moving values
>>>> to/from userspace to the kernel. Interfacing to the demods to allow th=
em
>>>> to interact with set/get property requests, if they chose to do so.
>>>> Quite a lot of changes internally and to the user facing API.
>>>>
>>>> If you're planning to test then you'll need the tune-v0.0.5.c to see t=
he
>>>> different. (steventoth.net/linux/s2/tune-v0.0.5.tgz)
>>>>
>>>> In addition, some related news:
>>>>
>>>> mkrufky spent some time adding S2API isdb-t support to the siano drive=
r,
>>>> that's working pretty well - tuning via the S2API app.
>>>>
>>>> Two tree here, offering slightly different approaches, one with S2API,
>>>> one using some spare bits in the DVB-T tuning fields.
>>>>
>>>> http://linuxtv.org/hg/~mkrufky/sms1xxx-s2api-isdbt/
>>>> http://linuxtv.org/hg/~mkrufky/sms1xxx-isdbt-as-dvbt/
>>>>
>>>> (See tune-v0.0.5.tgz for example ISDB-T tuning code)
>>>>
>>>> If you're interested in seeing the impact of switching to S2API for th=
is
>>>> driver, see the set_frontend() func, it's a small change - just a few
>>>> lines to reference the dtv_frontend_properties cache.
>>>>
>>>> I don't think we're quite ready to announce we've conquered the comple=
te
>>>> ISDB-T API, so don't assume that this is concrete.... As we experiment
>>>> with other ISDB-T products we'll probably find reasons to tweak the API
>>>> a little further as a standard begins to form..... but tuning through a
>>>> clean API is a great step forward, and its working now, today. Thank y=
ou
>>>> mkrufky :)
>>>>
>>>> Hans Werner sent a large patch for the multifrontend HVR3000/HVR4000
>>>> combined DVB-T/DVB-S/S2 support for the S2API tree. (Thanks Hans - this
>>>> was obviously a lot of manual merge work, it's greatly appreciated.)
>>>>
>>>> What would everyone like to see happen with this patch?
>>>>
>>>> Would you prefer to see this dealt with outside of the S2API discussio=
n,
>>>> or would you like to see this included and merged? Let me know your
>>>> thoughts. Andreas also has the multifrontend thread running, so comment
>>>> here if you would like to see this as part of the S2API patches, or
>>>> comment on the Andreas thread of you want this as a separate patchset =
at
>>>> a later date.
>>>>
>>>> Darron Broad has offered to bring the cx24116.c driver up to date with
>>>> some additions he has in his repositories. With any luck we may see
>>>> these merged into the current cx24116 driver within a few days. Thank
>>>> you Darron.
>>>>
>>>> Patrick, I haven't looked at your 1.7MHz bandwidth suggestion - I'm op=
en
>>>> to ideas on how you think we should do this. Take a look at todays
>>>> linux/dvb/frontend.h and see if these updates help, or whether you need
>>>> more changes.
>>>>
>>>> Igor has been busy patching the szap-s2 tool
>>>> (http://liplianindvb.sourceforge.net/hg/szap-s2/) so many thanks to
>>>> Igor! Gregoire has been running some basic tests and appears to be
>>>> having some success, that's encouraging. Thank you.
>>>>
>>>> What's next?
>>>>
>>>> Now's probably a good time to start patching dvb-apps. I think the
>>>> frontend.h changes are close enough for that work to begin. This will
>>>> probably start Friday, so keep your eyes and open for the
>>>> stoth/s2api-dvb-apps tree appearing ... and an announcement here.
>>>>
>>>> Thanks again to everyone, your efforts are appreciated!
>>>>
>>>> Regards,
>>>>
>>>> Steve
>>> Good work.
>>> I've just gave it a try:
>>>
>>> First i tried old api (kaffeine)-> everything works as expected.
>>> Then i tried new API (with latest tune.c) -> nova-t and nova-s work,
>>> cinergyT2 doesn't. I've also noticed that FE_SET_PROPERTY ioctl always
>>> return -1, even when success..
>>> Then i tried old api again -> now dvb-s doesn't lock and dvb-t always
>>> lock on the freq used in tune.c
>> Christophe, thanks for the feedback. I'm not familiar with the cinergyT2
>> driver so I'll look into this tonight and see what's causing the tuning
>> to fail.
>>
>> Thanks for highlighting this.
> =

> As far  as i understand, the cinergyT2 driver is a bit unusual, e.g. =

> dvb_register_frontend is never called (hence no dtv_* log messages). I do=
n't =

> know if there is others drivers like this, but this has to be investigate=
d =

> cause rewritting all drivers for S2API could be a bit of work :)
> =

> P.S.
> I think there is an alternate driver for cinergyT2 actually in developeme=
nt =

> but idon't remember where it's located neither its state.
> =

> =

> =


Good to know. (I also saw your followup email). I have zero experience =

with the cinergyT2 but the old api should still be working reliably. I =

plan to investigate this, sounds like a bug! :)

Regards,

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
