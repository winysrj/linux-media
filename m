Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KWKNW-0003qJ-Rt
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 02:19:48 +0200
Received: by wa-out-1112.google.com with SMTP id n7so73300wag.13
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 17:19:41 -0700 (PDT)
Message-ID: <7641eb8f0808211719l520f781aj9e916317edb8506e@mail.gmail.com>
Date: Fri, 22 Aug 2008 02:19:41 +0200
From: Beth <beth.null@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <917476.27404.qm@web46113.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808210745j6c99b53boe55dcc580a5875b1@mail.gmail.com>
	<917476.27404.qm@web46113.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

Ummmmmmmmmmmmm, that's incredible.

By two things, first for a silly stupid and more stupid thing, there
are a lot of  channels with 0:0 at its vid and aid, I assume that if
scan was finding channels it is doing on the correct way. This
afternoon I was doing tests on xp and I found that for that channel
the are 167 for video and 108 for audio, as yours (I smile when I saw
yours).

The second, I had learned a lot, a lot about dvb, I need to learn much
more but it is a funny way of learning.

Well, and the big question, why scan didn't found the vid and aid for
a lot of channels?

> You might want to look through your scan file and verify that most
> entries have other-than-0 for the PIDs.  Other than a few data or
> inactive channels, most should have at least audio, and for TV, a
> video PID as well.  My scan results from one card sometimes miss the
> PIDs, which I haven't traced further.
>

538 channels with 0:0 at vid:aid, of 1353, I dont know if that is
normal or if I must to re-scan.

>
> Anyway, I'm not sure if the programs you use are capable of dynamically
> determining the relevant PIDs based on the service number (30222) --
> I know mine don't, so if a channel changes PIDs (as those at 28E do
> rather frequently), I no longer receive the correct data; and I've
> read, but not acted upon, that there are updated user programs that do
> adjust dynamically...

I really don't know if this is possible.

>
> That explains why your files are so small -- you don't have the video
> and audio PIDs; only PID 0 and a few other random IDs (one is a bit of
> video, but the audio PID 108 is missing completely).
>
> Probably, if you manually change the video and audio PIDs from 0 to
> the values I have, you'll receive the data you need.
>
>

Is the first thing I made, and yessss, I get video&audio :)

>
>> me. There is
>> something that I don't understand, if I tune a channel
>> with szap2, why
>> the stream has so many pids?, and which pids the programs
>> take to
>> reproduce the video?, or the programs don't know
>
> I suspect the additional PIDs you see from `tspids' are accidental,
> or corruptions in the data stream.
>
> Within PID 0, your known service ID 30222 is mapped to be found under
> PID 1053 as you quoted in an earlier message from mplayer:
>   PROG: 30222 (10-th of 16), PMT: 1053
> Then mplayer goes on to look at PID 1053 and finds not only the video
> and audio PIDs, but several others, that I'll need to look at with
> dvbsnoop...  One moment...
> PID 53 is teletext;
> the remaining 11 PIDs appear to be data that you can ignore.
> These are 208, 222, 309, 392, 213, 253, 307, 356, 761, 888, 623.
> They can be seen in PID 1053 (dvbsnoop -s ts -tssubdecode -if ... 1053)
>
>
>
> I'm not sure why you didn't get at least this channel during your
> scan with the above valid audio and video PIDs.  Perhaps you can
> look through your scan file to see if there are many others like this.

At this point I am a bit lost, I must to re-read things a bit ;).

> On the transponders used by Canal+ Espana (or whatever it is), there
> will be a few channels with 0 for PIDs as above, but not too many.

(yes Canal+ Espa=F1a), in the entire scan I get 538 (but this is for all
the scan range)

> Over the entire Astra 19E satellite, the most such ``channels'' will
> be data channels at 12603, or perhaps on the german Premiere transponders,
> so if you are finding a lot more than that, then you are seeing a
> problem somewhere in parsing your scan properly.
>

I am going to take a eye on the "scan" program, to see what is doing wrong.

>
> Hope this is helpful!
>
> barry bouwsma
>

Helpful? you are my hero, man.

I don't know if tomorrow I will have free time at home, but as soon as
I can do it I am going to re-scan, re-check all, and inform you as
soon as I can.

Barry, a lot of thanks, thanks for your support, see you and kind
regards from Spain.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
