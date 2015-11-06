Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36394 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030815AbbKFLlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2015 06:41:44 -0500
Received: by wimw2 with SMTP id w2so28576013wim.1
        for <linux-media@vger.kernel.org>; Fri, 06 Nov 2015 03:41:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGydKfEk92ckCMxdF7HSXx0nV9EzwDNOmG5MWQH-CeLAXA@mail.gmail.com>
References: <CAMAAsr_Wf79Rcp7jt8crqGU+XTspQ=qURj2x8SOPvvJmxnyFjQ@mail.gmail.com>
	<CAAZRmGydKfEk92ckCMxdF7HSXx0nV9EzwDNOmG5MWQH-CeLAXA@mail.gmail.com>
Date: Fri, 6 Nov 2015 11:41:43 +0000
Message-ID: <CAMAAsr9ktug3AmCVXNOsbhOW7+mf=cTTY=Hw3-O_Ep2pOqL5+w@mail.gmail.com>
Subject: Re: Geniatech / Mygica T230
From: Mike Parkins <mike.bbcnews@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,
Here is the dmesg:

[ 2427.795294] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
[ 2427.795299] power control: 1
[ 2428.030801] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 2428.030962] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[ 2428.033853] i2c i2c-17: Added multiplexed i2c bus 18
[ 2428.033858] si2168 17-0064: Silicon Labs Si2168 successfully attached
[ 2428.037201] si2157 18-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[ 2428.037213] usb 2-3: DVB: registering adapter 0 frontend 0 (Silicon
Labs Si2168)...
[ 2428.037651] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/input/input22
[ 2428.037822] dvb-usb: schedule remote query interval to 100 msecs.
[ 2428.037825] power control: 0
[ 2428.037931] dvb-usb: Mygica T230 DVB-T/T2/C successfully
initialized and connected.
[ 2443.077697] power control: 1
[ 2443.316664] si2168 17-0064: found a 'Silicon Labs Si2168-B40'
[ 2443.330381] si2168 17-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[ 2443.914601] si2168 17-0064: firmware version: 4.0.4
[ 2443.925860] si2157 18-0060: found a 'Silicon Labs Si2158-A20'
[ 2443.925893] si2157 18-0060: downloading firmware from file
'dvb-tuner-si2158-a20-01.fw'
[ 2444.992678] si2157 18-0060: firmware version: 2.1.6
[ 2445.300551] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2445.308867] dmxdev: section callback 00 b0 65 10 44 c5
[ 2445.310228] function : dvb_dmxdev_filter_set, PID=0x0064, flags=05, timeout=0
[ 2445.328722] dmxdev: section callback 02 b0 ac 10 44 c3
[ 2445.330152] function : dvb_dmxdev_filter_set, PID=0x00c8, flags=05, timeout=0
[ 2445.351512] dmxdev: section callback 02 b0 a4 10 bf c3
[ 2445.352869] function : dvb_dmxdev_filter_set, PID=0x012c, flags=05, timeout=0
[ 2445.445188] dmxdev: section callback 02 b0 a4 10 c0 e7
[ 2445.446547] function : dvb_dmxdev_filter_set, PID=0x01f4, flags=05, timeout=0
[ 2445.455193] dmxdev: section callback 02 b0 80 11 00 c1
[ 2445.456549] function : dvb_dmxdev_filter_set, PID=0x0a8c, flags=05, timeout=0
[ 2445.555496] dmxdev: section callback 02 b0 73 11 40 c1
[ 2445.556851] function : dvb_dmxdev_filter_set, PID=0x0190, flags=05, timeout=0
[ 2446.560312] function : dvb_dmxdev_filter_set, PID=0x02bc, flags=05, timeout=0
[ 2447.563434] function : dvb_dmxdev_filter_set, PID=0x0320, flags=05, timeout=0
[ 2448.566597] function : dvb_dmxdev_filter_set, PID=0x0258, flags=05, timeout=0
[ 2449.569747] function : dvb_dmxdev_filter_set, PID=0x0578, flags=05, timeout=0
[ 2450.572904] function : dvb_dmxdev_filter_set, PID=0x05dc, flags=05, timeout=0
[ 2451.576058] function : dvb_dmxdev_filter_set, PID=0x0640, flags=05, timeout=0
[ 2452.579212] function : dvb_dmxdev_filter_set, PID=0x06a4, flags=05, timeout=0
[ 2453.582369] function : dvb_dmxdev_filter_set, PID=0x0708, flags=05, timeout=0
[ 2454.585524] function : dvb_dmxdev_filter_set, PID=0x076c, flags=05, timeout=0
[ 2455.588533] function : dvb_dmxdev_filter_set, PID=0x07d0, flags=05, timeout=0
[ 2456.591563] function : dvb_dmxdev_filter_set, PID=0x0c80, flags=05, timeout=0
[ 2457.594595] function : dvb_dmxdev_filter_set, PID=0x03e8, flags=05, timeout=0
[ 2458.597793] function : dvb_dmxdev_filter_set, PID=0x044c, flags=05, timeout=0
[ 2459.600934] function : dvb_dmxdev_filter_set, PID=0x04b0, flags=05, timeout=0
[ 2460.604085] function : dvb_dmxdev_filter_set, PID=0x0514, flags=05, timeout=0
[ 2461.607246] function : dvb_dmxdev_filter_set, PID=0x0384, flags=05, timeout=0
[ 2462.610396] function : dvb_dmxdev_filter_set, PID=0x0010, flags=05, timeout=0
[ 2474.630386] function : dvb_dmxdev_filter_set, PID=0x0011, flags=05, timeout=0
[ 2476.942501] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2478.356279] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2479.666940] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2480.979264] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2482.290109] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2483.600647] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2485.116700] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2486.633288] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05, timeout=0
[ 2487.640495] power control: 0

and here is the irc log from August when I first asked about this:

* Topic for #linuxtv set by unknown (Thu May 29 20:24:17 2008)
<mp_> is there anyone can help with a T230 usb DVB stick please?
* debianuser1 is now known as debianuser
<TrSqr> mp_, DVB-C with that?
<mp_> no, dvb-t
<mp_> it works as far as tuning in a mux but then no TS appears
<TrSqr> run: dmesg | pastebinit
<TrSqr> and send me the link produced
<TrSqr> I'd guess: you are missing either demod or tuner firmware from
/lib/firmware
<mp_> firmware is ok, 2 files and I confirmed the md5sum
<mp_> can't get pastebinit to work! bad API key
<mp_> i can cut/paste the dmesg text for the usb device if that helps
<TrSqr> please cut/paste in http://pastebin.com
<mp_> it is mp-t230
<TrSqr> that doesn't cover the time when you're trying to watch the stream...
<TrSqr> (which is why I wanted the complete dmesg in the first place)
<mp_> ok, but there's nothing there - i will put up whole dmesg as mp-t230all
<TrSqr> can you send me a link to that, I cannot find it?
<TrSqr> when you try to tune for the first time, the firmware for both
demod and the tuner is loaded - and that prints a line in the log
<mp_> mp-t230all is there now
<mp_> http://pastebin.com/MEcDcHcb
<TrSqr> https://github.com/OpenELEC/dvb-firmware/raw/master/firmware/dvb-demod-si2168-b40-01.fw
<TrSqr> most likely not your problem, but try with that firmware (it's
4.0.19, whereas you have 4.0.4 currently)
<mp_> ok, will try it now
<mp_> i sed firmware from linuxtv page on T230 which had md5sum
<mp_> used
<TrSqr> but yeah, everything looks good there, can't see anything
alarming in that log
<TrSqr> hmm.. I can see the wiki page has md5sums but no firmware
files, just a link to openelec firmware collection
<TrSqr> and the firmware in the OE dvb-firmware was updated recently.
I bet the wiki page wasn't :P
<mp_> firmware swapped....
<TrSqr> do you see the new version number in dmesg now when you try to
tune for the first time? (you did reboot or reload the si2168 module?)
<mp_> :-)
<mp_> i pulled the stick out and reinserted.... it tunes and now I
have a PAT and a NIT!
<TrSqr> so either the FW helped or a reset of the stick :D
<mp_> oh it must be firmware, I have replugged the stick many times!
<mp_> thank you very much :-)
<TrSqr> no worries
<mp_> mythtv still not working, but i'm getting nearer I think
<mp_> will try me-tv
<mp_> it was short lived :-(
<mp_> now same as before...no TS at all
<mp_> dmesg shows it loaded 4.0.19 firmware
<mp_> I guess it was the replug that made it flicker into life briefly
<mp_> any other ideas Olli?
<TrSqr> not really :(
<TrSqr> if I remember correctly myth doesn't support frontends with
multiple delivery systems
<mp_> it works fine in windows with the supplied drivers
<TrSqr> tvheadend does
<TrSqr> but I can be mistaken, haven't really used myth that much
<mp_> problem is more fundamental though - nothing comes out of dvr0
after tuning
<mp_> something is muting it
<mp_> http://pastebin.com/TJ9yyTD5 is what I get now, as before
<TrSqr> that's strange indeed
* kierank_ is now known as kierank
<mp_> is anyone here?
<devinheitmueller> mp_: Many of the key people you would be looking
for are at the MC summit.
<devinheitmueller> (hence I suspect it’s going to be pretty quiet today)
<mp_> just my luck :-(
<devinheitmueller> That said, if you’ve got a question, you can always
ask and somebody might know the answer.
<mp_> ok, TrSqr was helping me earlier but he ran out of ideas...
<mp_> I have a T230 Mygica/Geniatech DVB-T/T2 usb stick which refuses
to output a TS
<devinheitmueller> Well the IRC logbot has been down for nearly 12
months, so I cannot see the history.  :-)
<devinheitmueller> Is there an existing driver, or are you trying to
write a driver?
<mp_> it is supported in the kernel, I am on 4.09 now
<devinheitmueller> ok
<mp_> with Mint 17.2 up to date
<mp_> I had the suggested firmware from linuxtv.org, md5sums matching
<devinheitmueller> Which app are you using?
<mp_> all of them, I've tried dvbv5-scan, dvblast, mythtv, vlc, me-tv
<devinheitmueller> Are you getting a signal lock?
<mp_> they all manage to tune it in and I get a signal reading from
dvb-fe-tool --femon
<devinheitmueller> Is the signal status 0x1F?
<devinheitmueller> Because many of the demods will return a garbage
value if the tuner isn’t actually locked.
<mp_> I can get all the London muxes, yes
<devinheitmueller> (i.e. you’ll see *something* for a signal reading,
but it won’t be valid)
<mp_> yes, dvblast says it has signal lock, stable FEC and sync
<devinheitmueller> Do you have another device to test with?
<mp_> yes, an older dvbstick works fine
<devinheitmueller> Ok.
<mp_> and this one works in Windows!
<devinheitmueller> And you’re using the scan file generated with the
older stick.
<devinheitmueller> Oh, I don’t doubt it works in Windows.
<mp_> :-)
<devinheitmueller> There are plenty of shit drivers in Linux, and I
won’t be quick to blame the hardware.
<mp_> dvblast says... frontend has acquired lock
<mp_> warning: no DVR output, resetting
<devinheitmueller> (I feel like I can make that criticism and not be
considered a troll, given I wrote some of the drivers in question).
<mp_> :-)
<devinheitmueller> Have you tried running dvbtraffic?
<devinheitmueller> If not, you should, as that would rule out a
problem with PID filtering.
<mp_> yes, and "cat /dev/dvb/adaptor0/dvr0"
<mp_> nothing comes...
<devinheitmueller> Yeah, don’t rely on “cat”.  That won’t help you if
the PIDs are setup wrong.
<devinheitmueller> If the PIDs are misconfigured, you won’t see any
stream on dvr0, through no fault of the driver.
<devinheitmueller> So dvbtraffic shows *no* packets arriving?
<devinheitmueller> On *any* PID?
<mp_> it sits there blankly
<mp_> no traffic at all
<devinheitmueller> Ok.
<devinheitmueller> Is this on an x86 system?
<mp_> yes
<devinheitmueller> Ok.  You would be surprised how many times I’ve had
a convesation like this where it takes ten minutes for the user to
point out he’s on a Raspberry Pi.
<devinheitmueller> Any errors in dmesg?
<mp_> no, seems to be recognised ok, then loads firmware at first tuning
<mp_> no errors reported
<mp_> i should mention that it seems to have a short burst of activity
at first tuning, but then gives up very quickly
<devinheitmueller> If you do the tuning request with tzap, see it
lock, and then yank out the ariel, does the lock go away?
<mp_> does tzap need a channel file? I haven't been able to generate one yet
<devinheitmueller> Yes.
<devinheitmueller> You should be able to generate a channels.conf with
the old stick.
<devinheitmueller> Wait, what are you running to do the tune before
you run dvbtraffic?
<mp_> dvbv5-scan
<mp_> it produces this.....
<devinheitmueller> scan is a scanner.  It doesn’t tune.
<mp_> mp@Aurorabox ~ $ dvbv5-scan uk-CrystalPalace -I CHANNEL
<mp_> Scanning frequency #1 490000000
<mp_> Lock   (0x1f) C/N= 22.25dB
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while waiting for PAT table
<devinheitmueller> Do you kill dvbv5-scan before running dvbtraffic?
<mp_> yes, otherwise it just loops
<devinheitmueller> Ok, that won’t work.
<devinheitmueller> If you close the app that is controlling the
frontend, any output to dvr0 will automatically stop.
<mp_> i ran it once after powerup and it produced lots of channels,
only did it once though
<devinheitmueller> Oh wait.
<devinheitmueller> So if you unplug/replug the stick, you will get channels?
<mp_> yes, briefly....
<devinheitmueller> So the first run of dvbv5-scan works, but if you
run it again you’ll get nothing?
<mp_> yes, but mythtv or me-tv have never produced live tv, even after powerup
<devinheitmueller> Yeah, but those apps open/close the device a
handful of times on startup.
<devinheitmueller> Try this:
<devinheitmueller> 1.  Unplug stick.  Plug stick back in
<mp_> mythtv has logged 70 ish channels and has a week of EPG info
<devinheitmueller> 2.  Run dvbv5-scan.  See if you get good results
<devinheitmueller> 3.  Run dvbv5-scan again.  See if you get no results.
<mp_> i do, I have done it a few times
<devinheitmueller> So does it work exactly once?  Or does it work a
few times and then starts failing?
<devinheitmueller> If it works exactly once, then I have a good idea
where the problem is.
<mp_> it varies, sometimes I get channels for the first mux only,
sometimes for more than one, then it dies
<mp_> or maybe not, my brain hurts today
<mp_> you could be right
<devinheitmueller> Right.  So let’s run the exact three steps I outlined above.
<mp_> ok,
<devinheitmueller> Ping me when you’ve done that.
<mp_> ok, it did as you said - first tune to 490MHz produced about 30
channels, then it died
<devinheitmueller> When you say “died”, you mean it didn’t find any
other channels?
<mp_> it did this for the next 8 muxes.....
<mp_> Scanning frequency #2 514000000
<mp_> Lock   (0x1f)
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while reading the PMT table for service 0x20a9
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while reading the PMT table for service 0x20c0
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while reading the PMT table for service 0x20c1
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while reading the PMT table for service 0x20fa
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while reading the PMT table for service 0x2100
<mp_> ERROR    dvb_read_sections: no data read on section filter
<mp_> ERROR    error while reading the PMT table for service 0x2104
<devinheitmueller> Please use pastebin.  Don’t paste large amounts of
output to the IRC window.
<mp_> sorry, thought it go on one line
<devinheitmueller> Hmm, I wonder if mchehab closes the frontend
between tuning requests.
<devinheitmueller> Looking at the source, looks like he only opens it
once at the start of the scan (which is good, btw)
<mp_> dvbv5-scan was going through my channel file with all the muxes
in it, if that helps
<devinheitmueller> Yeah, that is expected.
<devinheitmueller> My guess is something resets the demodulator, and
the default TS output configuration doesn’t match what the board
requires.
<mchehab> devinheitmueller: no, dvbv5-scan only closes the frontend at the end
<devinheitmueller> (i.e. the default is parallel, but the device
requires serieal)
<mchehab> when the app finishes
<devinheitmueller> mchehab: Yeah, that’s what I’m seeing in the code.  Cool.
<mp_> From googling, i think it works in open-elec on the pi but I
don't have that
* mchehab can't look on mp_'s issue...
<devinheitmueller> mp_: It could very well be a different version of
the driver.  Drivers are constantly getting broken and fixed with each
release.
<mchehab> we finished the last day of the MC summit a few mins ago...
<devinheitmueller> mchehab: Nice.
<devinheitmueller> I was reading your notes a few minutes ago.
* mchehab is needing to do something else than thinking on codes ATM :)
<devinheitmueller> :-)
<mchehab> the subject discussed today was quite complex...
<mp_> for what its worth, I appreciate your work on dvb, I have been
playing with it for 7 or 8 years!
<devinheitmueller> It’s been four years since I asked this, but has
anybody bothered to look at the Windows media graph implementation?
<mp_> as a user of course...
<devinheitmueller> mchehab: It’s been around since Windows XP, and
does most of the things you’re trying to accomplish with the MC.
<devinheitmueller> I’m not saying you guys should copy it, but it’s
been around for a long time and there’s plenty you could learn from
how they dealt with some of these problems.
<devinheitmueller> mp_: sorry, that question was directed at mchehab
with regards to the MC infrastructure they are building.
<mchehab> devinheitmueller: no, I didn't check.
<mchehab> I'm not familiar with Windows XP programming
<mp_> its ok, do you have any idea what might be going on with my T230?
<mchehab> nor I want to deal with eventual patent issues by looking on it ;)
<mchehab> I think we came with a good way to map things on MC though
<devinheitmueller> It’s not perfect, but people have been building
media applications with it for fifteen years.  Building a whole new
subsystem and not looking at a stable API in another OS that has been
around for years seems a bit foolish.
<mchehab> implementing it is a different issue
<mchehab> lots of work to be done
<devinheitmueller> I gave up on MC years ago.  Give me a call when I
can finally write an application which can reliably associate a VBI,
V4L2, and ALSA device automatically.
<mchehab> devinheitmueller: well, yo can do that already with what's
done on shuah's experimental branch
<mchehab> but we'll be changing some things
<mchehab> so, better to wait for us to do the rework
<devinheitmueller> Yeah, I saw her branch, and reached out to her
privately about some race conditions and other problems I suspect
she’ll expose.
<mchehab> I froze any changes (except bug fixes) at MC-related stuff
while we don't do such rework
<mchehab> yeah, shuah commented that with me
<mchehab> thanks for helping her!
<devinheitmueller> Everything I’ve seen makes me continue to believe
that the tuner locking won’t be possible without breaking
compatibility with existing apps.
<mchehab> shuah is here at the MC summit too
<mp_> this is the result after replugging the stick...
http://pastebin.com/1maddqke
<devinheitmueller> I’m not offering that as a criticism of her work —
just a statement that I don’t think the problem *can* be solved
without breaking the ABI.
<devinheitmueller> mchehab: Yeah, I saw.  Good to get all the key
players in the same room.
<devinheitmueller> I generally find such meetings very useful.  I just
cannot afford to do it at my own personal expense anymore.
<mchehab> devinheitmueller: well, shuah said she added your testcases
on her tests
<mchehab> we'll try hard to make it work without breaking the ABI
<devinheitmueller> I need to followup with her on that.  If the test
cases didn’t expose the bugs I’m thinking of, they probably need to be
reworked a bit.
<mchehab> yeah
<devinheitmueller> brb
<mp_> should I come back later?
<devinheitmueller> Sorry, I’m back.
<mp_> hi Devin :-)
<devinheitmueller> Am I correct in that after you run the dvbv5-scan
command and start seeing failures, if you run it again that even the
first transponder no longer returns channels?
<mp_> yep
<devinheitmueller> What’s your USB ID?
<devinheitmueller> (run “lsusb” -n"
<mp_> Bus 002 Device 007: ID 0572:c688 Conexant Systems (Rockwell), Inc.
<mp_> lsusb -n doesn't work but thats what lsusb on its own produces
<devinheitmueller> ok.
* devinheitmueller looks at the code
<devinheitmueller> Do you see messages in dmesg that say “downloading
firmware from file…”?
<mp_> yes, for both files
<devinheitmueller> Do you get those messages every time you run
dvbv5-scan?  Or only the first time you run it?
<mp_> only once
<devinheitmueller> Do you have any modprobe options set for dvb-core?
In particular, dvb_powerdown_on_sleep or dvb_shutdown_timeout?
<mp_> not to my knowledge, which file is that?
<devinheitmueller> if you didn’t explicilty set them, then don’t worry about it.
<devinheitmueller> So my guess is that the TS output control only gets
run once in the init() routine, the device reset line gets strobed due
to a bad GPIO config, and then for reasons unknown the init() routine
isn’t being re-run when you close and reopen the frontend.
<mp_> o....k.
<mp_> if its a config thing, thats fixable maybe?
<devinheitmueller> Perhaps.  There are all sorts of reasons a GPIO
line could get strobed.
<devinheitmueller> I probably cannot say more without having the stick
in front of me and the ability to add more debug to the driver.
<devinheitmueller> You should probably talk to crope, since he’s the
resident expert on the si2168.
<mp_> should I email him?
<devinheitmueller> Sure.
<devinheitmueller> Setting the TS output config at init is a seemingly
reasonable thing to do, but it exposes you to bugs in the bridge
should the demod get reset unexpectedly.
<devinheitmueller> Setting the output explicitly on every tune take a
few extra milliseconds but avoids such bugs.
<mp_> right...
<devinheitmueller> As for why the init() routine isn’t being called on
every frontend open, I’m not sure.  Perhaps some logic in dvb-core
that i’m overlooking.  Been a while since I played with that stuff.
<devinheitmueller> Do you still have the MythTV backend running when
you’re doing all this testing?
<mp_> no, it takes over the frontend
<devinheitmueller> Ok, good.
<TrSqr> devinheitmueller, are you saying that we should try to move
the TS mode setting from init to set_frontend?
<devinheitmueller> Definitely worth a try to see if it makes a difference.
<devinheitmueller> If it starts working, then you know it’s a problem
with the TS output, and with being reset.
<TrSqr> I've got the stick at home - I can try some time
<TrSqr> (I think it was me who moved the ts mode setting from
set_frontend to init earlier...)
<TrSqr> mp_, which kernel you have and did you build media_build recently?
<mp_> i did a dpkg upgrade with the 4.09 kernel
<mp_> before that it did not see the T230
<TrSqr> so you have 4.0.9 kernel, no media_build?
<devinheitmueller> TrSqr: Yeah, like I said:  I can understand why
somebody would move it to init in the interest of cleanliness and
eliminating what could be seen as a duplicate call run on every tuning
request.  But I’ve definitely seen cases like this where it exposes
bugs in the bridge.
<mp_> not familiar with media build
<TrSqr> that's fine, just want to know your setup, in case I can't see
the issue with my system
<devinheitmueller> All that said, give that a try and see if it helps.
If it does, then that narrows down the source of the problem
considerably.
<TrSqr> devinheitmueller: good points. I'll check that out.
<mp_> do I have the latest dvb modules in my kernel?
<TrSqr> no, not really, but rather recent anyway - I don't think there
are any relevant changes after that
<mp_> ok
<TrSqr> http://git.linuxtv.org/cgit.cgi/media_build.git/about/
<TrSqr> if you want, you can add the latest media_tree to ~any kernel
by following the instruction there
<mp_> ok, noted
<TrSqr> but I doubt that will help in your case
* [crope] (crope@otitsun.oulu.fi): Antti Palosaari www.palosaari.fi
* [crope] #linuxtv
* [crope] kornbluth.freenode.net :Frankfurt, Germany
* [crope] idle 96:04:21, signon: Mon Jul 27 14:42:22
* [crope] End of WHOIS list.

On 6 November 2015 at 06:34, Olli Salonen <olli.salonen@iki.fi> wrote:
> Hi Mike,
>
> Can you also paste the dmesg output here, so we can see if the driver
> is starting up correctly?
>
> Cheers,
> -olli
>
> On 3 November 2015 at 23:35, Mike Parkins <mike.bbcnews@gmail.com> wrote:
>> Hi,
>> I can't get this dvb-t2 USB device to work despite the linuxtv site
>> claiming it is working since 3.19 kernel. I tried talking to the driver
>> team on IRC a few months ago and they said they would look at it but I have
>> recently pulled the linuxtv git tree and compiled it on my Linux Mint 4.09
>> kernel system and it has not changed. Below is the output of a typical
>> tuning attempt:
>>
>> mp@Aurorabox ~ $ dvbv5-scan uk-CrystalPalace -I CHANNEL
>> Scanning frequency #1 490000000
>> Lock   (0x1f) C/N= 28.25dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x11c0
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1200
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1240
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1280
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1600
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1640
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1680
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x16c0
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1700
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1740
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1780
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1804
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1a40
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1a80
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1ac0
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1b00
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the PMT table for service 0x1c00
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the NIT table
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while reading the SDT table
>> WARNING: no SDT table - storing channel(s) without their names
>> Storing Service ID 4164: '490.00MHz#4164'
>> Storing Service ID 4287: '490.00MHz#4287'
>> Storing Service ID 4288: '490.00MHz#4288'
>> Storing Service ID 4352: '490.00MHz#4352'
>> Storing Service ID 4416: '490.00MHz#4416'
>> Scanning frequency #2 514000000
>> Lock   (0x1f) Signal= -29.00dBm C/N= 21.50dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #3 545833000
>> Lock   (0x1f) Signal= -30.00dBm C/N= 31.00dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #4 506000000
>> Lock   (0x1f) Signal= -30.00dBm C/N= 28.50dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #5 482000000
>> Lock   (0x1f) Signal= -30.00dBm C/N= 21.75dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #6 529833000
>> Lock   (0x1f) Signal= -29.00dBm C/N= 21.75dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #7 538000000
>> Lock   (0x1f) Signal= -29.00dBm C/N= 16.50dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #8 570000000
>> Lock   (0x1f) Signal= -46.00dBm C/N= 26.50dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> Scanning frequency #9 586000000
>> Lock   (0x1f) Signal= -39.00dBm C/N= 26.25dB
>> ERROR    dvb_read_sections: no data read on section filter
>> ERROR    error while waiting for PAT table
>> mp@Aurorabox ~ $
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
