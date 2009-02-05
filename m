Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:35256 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZBENI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 08:08:57 -0500
Received: by ug-out-1314.google.com with SMTP id 39so156203ugf.37
        for <linux-media@vger.kernel.org>; Thu, 05 Feb 2009 05:08:54 -0800 (PST)
Date: Thu, 05 Feb 2009 09:08:47 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
 on HDchannels
To: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<1232998154.24736.2@manu-laptop> <497F66E5.9060901@gmail.com>
	<c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>
	<497F78E9.9090608@gmail.com>
	<157f4a8c0902021443s5b567aap461b50d305088699@mail.gmail.com>
In-Reply-To: <157f4a8c0902021443s5b567aap461b50d305088699@mail.gmail.com>
Message-Id: <1233839327.6096.1@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 02.02.2009 18:43:33, Chris Silva a écrit :
> On Tue, Jan 27, 2009 at 9:13 PM, Manu Abraham 
> <abraham.manu@gmail.com>
> wrote:
> > Alex Betis wrote:
> >> On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham
> <abraham.manu@gmail.com>wrote:
> >>
> >>>> Hmm OK, but is there by any chance a fix for those issues
> somewhere or
> >>>> in the pipe at least? I am willing to test (as I already
> offered), I
> >>>> can compile the drivers, spread printk or whatever else is 
> needed
> to
> >>>> get useful reports. Let me know if I can help sort this problem.
> BTW in
> >>>> my case it is DVB-S2 30000 SR and FEC 5/6.
> >>> It was quite not appreciable on my part to provide a fix or reply
> in
> >>> time nor spend much time on it earlier, but that said i was quite
> >>> stuck up with some other things.
> >>>
> >>> Can you please pull a copy of the multiproto tree
> >>> http://jusst.de/hg/multiproto or the v4l-dvb tree from
> >>> http://jusst.de/hg/v4l-dvb
> >>>
> >>> and apply the following patch and comment what your result is ?
> >>> Before applying please do check whether you still have the 
> issues.
> >>
> >> Manu,
> >> I've tried to increase those timers long ago when played around
> with my card
> >> (Twinhan 1041) and scan utility.
> >> I must say that I've concentrated mostly on DVB-S channels that
> wasn't
> >> always locking.
> >> I didn't notice much improvements. The thing that did help was
> increasing
> >> the resolution of scan zigzags.
> >
> > With regards to the zig-zag, one bug is fixed in the v4l-dvb tree.
> > Most likely you haven't tried that change.
> >
> >> I've sent a patch on that ML and people were happy with the
> results.
> >
> > I did look at your patch, but that was completely against the 
> tuning
> > algorithm.
> >
> > [..]
> >
> >> I believe DVB-S2 lock suffer from the same problem, but in that
> case the
> >> zigzag is done in the chip and not in the driver.
> >
> > Along with the patch i sent, does the attached patch help you in
> > anyway (This works out for DVB-S2 only)?
> >
> 
> Manu,
> 
> I've tried both multiproto branches you indicated above, *with* and
> *without* the patches you sent to the ML (fix_iterations.patch and
> increase timeout.patch) on this thread.
> Sadly, same behavior as S2API V4L-DVB current branch. No lock on 
> 30000
> 3/4 channels. It achieves a 0.5 second jittery sound but no image. It
> seems the driver is struggling to correctly lock on that channel, but
> doesn't get there in time... Or maybe the hardware... Dunno...
> 
> Channels like
> 
> ASTRA HD
> +;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1279=27:0;1283=deu:0:0:131:133:6:0
> PREMIERE HD,PREM
> HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:767=27:0;771=deu,772=eng:32:1837,1833,1834,9C4:129:133:6:0
> DISCOVERY HD,DISC
> HD;PREMIERE:11914:hC910M2O35S1:S19.2E:27500:1023=27:0;1027=deu:32:1837,1833,1834,9C4:130:133:6
> 
> work just fine.
> 
> But channels like
> 
> National Geographic HD;National Geographic
> HD:11731:vC34M5O25S1:S30.0W:29000:6496=27:6497:0:1802:943:54:47:0
> MOV HD;MOV 
> HD:11731:vC34M5O25S1:S30.0W:29000:6512=27:6513=por:0:1802:944:54:47:0
> Sport TV - HD;Sport TV -
> HD:11731:vC34M5O25S1:S30.0W:29000:6528=27:6529=por:0:1802:945:54:47:0
> RTP HD;RTP 
> HD:11731:vC34M5O25S1:S30.0W:29000:6544=27:6545:0:1802:946:54:47:0
> TVCine 4 HD;TVCine 4
> HD:11731:vC34M5O25S1:S30.0W:29000:6560=27:6561:0:1802:947:54:47:0
> Disney Cinemagic
> HD:11731:vC34M5O25S1:S30.0W:29000:6576=27:6577=por:0:1802:948:54:47:0
> Eurosport 
> HD:11731:vC34M5O25S1:S30.0W:29000:6592=27:6593=por:0:1802:949:54:47:0
> 
> or
> 
> [0065];:12012:hC34M5S1:S30.0W:30000:4097:4098:4100:100:101:0:0:0
> [0066];:12012:hC34M5S1:S30.0W:30000:4105:4106:4100:100:102:0:0:0
> [0067];:12012:hC34M5S1:S30.0W:30000:4113:4114:4100:100:103:0:0:0
> [0068];:12012:hC34M5S1:S30.0W:30000:4121:4122:4100:100:104:0:0:0
> [0069];:12012:hC34M5S1:S30.0W:30000:4129:4130:4100:100:105:0:0:0
> [006a];:12012:hC34M5S1:S30.0W:30000:4137:4138:4100:100:106:0:0:0
> [006b];:12012:hC34M5S1:S30.0W:30000:4145:4146:4100:100:107:0:0:0
> 
> simply don't work.
> 
> BTW, I think the channels above that don't work have a 0x0B stream
> indication. Satellite operators are misleading on the stream (h.222)
> when in fact they are h.264. Read that were on the ML. Don't know if
> it affects anything, but hey... I have to try everything! ;)
> 
> I'm available to any tests necessary to fix this once and for all, if
> possible.

Could I suggest something (probably stupid): I think that the TT 3650 
is the same card but using USB, right (I mean it uses the stb0899/
stb6100 chips also)? So if someone could sniff the usb transactions 
during a successfull lock on a problematic channel (using windows 
then), we could see what is different.
I do not have neither Windows, neither this card, but a good soul could 
help us here.
Manu, is that sensible?
Bye
Manu (the other one ;-)



