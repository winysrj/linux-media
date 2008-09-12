Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Fri, 12 Sep 2008 08:26:30 +0200
References: <48CA0355.6080903@linuxtv.org>
In-Reply-To: <48CA0355.6080903@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809120826.31108.hftom@free.fr>
Cc: Steven Toth <stoth@hauppauge.com>
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

Le Friday 12 September 2008 07:51:17 Steven Toth, vous avez =E9crit=A0:
> Hello!
>
> More progress today, 7 new patches were merged - all related to the
> feedback and suggestions we had.... And a bugfix. :)
>
> The DTV_SET/GET command syntax has been rationalised, as Hans requested.
> This cleans up the application API nicely. Various internal improvements
> and code cleanup related to variable length arrays, moving values
> to/from userspace to the kernel. Interfacing to the demods to allow them
> to interact with set/get property requests, if they chose to do so.
> Quite a lot of changes internally and to the user facing API.
>
> If you're planning to test then you'll need the tune-v0.0.5.c to see the
> different. (steventoth.net/linux/s2/tune-v0.0.5.tgz)
>
> In addition, some related news:
>
> mkrufky spent some time adding S2API isdb-t support to the siano driver,
> that's working pretty well - tuning via the S2API app.
>
> Two tree here, offering slightly different approaches, one with S2API,
> one using some spare bits in the DVB-T tuning fields.
>
> http://linuxtv.org/hg/~mkrufky/sms1xxx-s2api-isdbt/
> http://linuxtv.org/hg/~mkrufky/sms1xxx-isdbt-as-dvbt/
>
> (See tune-v0.0.5.tgz for example ISDB-T tuning code)
>
> If you're interested in seeing the impact of switching to S2API for this
> driver, see the set_frontend() func, it's a small change - just a few
> lines to reference the dtv_frontend_properties cache.
>
> I don't think we're quite ready to announce we've conquered the complete
> ISDB-T API, so don't assume that this is concrete.... As we experiment
> with other ISDB-T products we'll probably find reasons to tweak the API
> a little further as a standard begins to form..... but tuning through a
> clean API is a great step forward, and its working now, today. Thank you
> mkrufky :)
>
> Hans Werner sent a large patch for the multifrontend HVR3000/HVR4000
> combined DVB-T/DVB-S/S2 support for the S2API tree. (Thanks Hans - this
> was obviously a lot of manual merge work, it's greatly appreciated.)
>
> What would everyone like to see happen with this patch?
>
> Would you prefer to see this dealt with outside of the S2API discussion,
> or would you like to see this included and merged? Let me know your
> thoughts. Andreas also has the multifrontend thread running, so comment
> here if you would like to see this as part of the S2API patches, or
> comment on the Andreas thread of you want this as a separate patchset at
> a later date.
>
> Darron Broad has offered to bring the cx24116.c driver up to date with
> some additions he has in his repositories. With any luck we may see
> these merged into the current cx24116 driver within a few days. Thank
> you Darron.
>
> Patrick, I haven't looked at your 1.7MHz bandwidth suggestion - I'm open
> to ideas on how you think we should do this. Take a look at todays
> linux/dvb/frontend.h and see if these updates help, or whether you need
> more changes.
>
> Igor has been busy patching the szap-s2 tool
> (http://liplianindvb.sourceforge.net/hg/szap-s2/) so many thanks to
> Igor! Gregoire has been running some basic tests and appears to be
> having some success, that's encouraging. Thank you.
>
> What's next?
>
> Now's probably a good time to start patching dvb-apps. I think the
> frontend.h changes are close enough for that work to begin. This will
> probably start Friday, so keep your eyes and open for the
> stoth/s2api-dvb-apps tree appearing ... and an announcement here.
>
> Thanks again to everyone, your efforts are appreciated!
>
> Regards,
>
> Steve

Good work.
I've just gave it a try:

First i tried old api (kaffeine)-> everything works as expected.
Then i tried new API (with latest tune.c) -> nova-t and nova-s work, cinerg=
yT2 =

doesn't. I've also noticed that FE_SET_PROPERTY ioctl always return -1, eve=
n =

when success..
Then i tried old api again -> now dvb-s doesn't lock and dvb-t always lock =
on =

the freq used in tune.c

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
