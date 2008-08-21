Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n58.bullet.mail.sp1.yahoo.com ([98.136.44.46])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KWDVw-0007cS-TF
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 19:00:03 +0200
Date: Thu, 21 Aug 2008 09:59:24 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Beth <beth.null@gmail.com>
In-Reply-To: <7641eb8f0808210745j6c99b53boe55dcc580a5875b1@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <917476.27404.qm@web46113.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
Reply-To: free_beer_for_all@yahoo.com
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

[Sent back to the linux-dvb list, so that others may possibly
benefit, or learn, or be annoyed, or something]


--- On Thu, 8/21/08, Beth <beth.null@gmail.com> wrote:

> Here is the output of tspids:
> 
> tspids < test_100M.ts
> tspids
> 1053 0 4353 313 167 4419 863

Hmmm...


> The channel that was tuned is on the channels.conf as:
> 
> TV GALICIA:11685:v:0:22000:0:0:30222:0

Thanks!  That tells me a lot.

I'm using a several-year old version of most DVB utilities, so the
exact format of my scan results differs slightly (many local hacks too).

I would expect to see something like
TV GALICIA:11685:v:1:22000:167:108:30222
                           ^^^ ^^^

(ignore the 1 in place of 0; I've hacked DiSEqC 1-4 instead of 0-3,
and the missing :0 at the end)

I expected you to have mostly PID 0 data, and suspected the video
and audio PIDs were missing.

You might want to look through your scan file and verify that most
entries have other-than-0 for the PIDs.  Other than a few data or
inactive channels, most should have at least audio, and for TV, a
video PID as well.  My scan results from one card sometimes miss the
PIDs, which I haven't traced further.


Anyway, I'm not sure if the programs you use are capable of dynamically
determining the relevant PIDs based on the service number (30222) --
I know mine don't, so if a channel changes PIDs (as those at 28E do
rather frequently), I no longer receive the correct data; and I've
read, but not acted upon, that there are updated user programs that do
adjust dynamically...

That explains why your files are so small -- you don't have the video
and audio PIDs; only PID 0 and a few other random IDs (one is a bit of
video, but the audio PID 108 is missing completely).

Probably, if you manually change the video and audio PIDs from 0 to
the values I have, you'll receive the data you need.



> me. There is
> something that I don't understand, if I tune a channel
> with szap2, why
> the stream has so many pids?, and which pids the programs
> take to
> reproduce the video?, or the programs don't know

I suspect the additional PIDs you see from `tspids' are accidental,
or corruptions in the data stream.

Within PID 0, your known service ID 30222 is mapped to be found under
PID 1053 as you quoted in an earlier message from mplayer:
   PROG: 30222 (10-th of 16), PMT: 1053
Then mplayer goes on to look at PID 1053 and finds not only the video
and audio PIDs, but several others, that I'll need to look at with
dvbsnoop...  One moment...
PID 53 is teletext;
the remaining 11 PIDs appear to be data that you can ignore.
These are 208, 222, 309, 392, 213, 253, 307, 356, 761, 888, 623.
They can be seen in PID 1053 (dvbsnoop -s ts -tssubdecode -if ... 1053)



I'm not sure why you didn't get at least this channel during your
scan with the above valid audio and video PIDs.  Perhaps you can
look through your scan file to see if there are many others like this.

At the time I made my scan, there was one program on this transponder
without valid PIDs, but that was several months ago, and may be no
longer correct:
[7600]:11685:v:1:22000:0:0:30208

On the transponders used by Canal+ Espana (or whatever it is), there
will be a few channels with 0 for PIDs as above, but not too many.
Over the entire Astra 19E satellite, the most such ``channels'' will
be data channels at 12603, or perhaps on the german Premiere transponders,
so if you are finding a lot more than that, then you are seeing a
problem somewhere in parsing your scan properly.


Hope this is helpful!

barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
