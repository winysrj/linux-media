Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n56.bullet.mail.sp1.yahoo.com ([98.136.44.52])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KYFQK-00071u-EG
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 09:26:38 +0200
Date: Wed, 27 Aug 2008 00:26:00 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Josef Wolf <jw@raven.inka.de>
In-Reply-To: <20080826224519.GL32022@raven.wolf.lan>
MIME-Version: 1.0
Message-ID: <949376.11164.qm@web46110.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

--- On Tue, 8/26/08, Josef Wolf <jw@raven.inka.de> wrote:

> >      ==> system_clock_reference_base: 859961626
> (0x3341f91a)  [= 90 kHz-Timestamp: 2:39:15.1291]
> 
> This is a PS pack header, right?

Correct:

Packet_start_code_prefix: 0x000001
Stream_id: 186 (0xba)  [= MPEG_pack_start (PS)]
Pack_header:
    fixed '01': 1 (0x01)
    system_clock_reference_base:
        bit[32..30]: 0 (0x00)
        marker_bit: 1 (0x01)
        bit[29..15]: 26243 (0x6683)
        marker_bit: 1 (0x01)
        bit[14..0]: 31002 (0x791a)
        marker_bit: 1 (0x01)
         ==> system_clock_reference_base: 859961626 (0x3341f91a)  [= 90 kHz-Timestamp: 2:39:15.1291]


> >          ==> PTS: 5154932522 (0x13342072a)  [= 90
> kHz-Timestamp: 15:54:37.0280]
> >          ==> DTS: 5154921721 (0x13341dcf9)  [= 90
> kHz-Timestamp: 15:54:36.9080]
> >          ==> PTS: 5154925321 (0x13341eb09)  [= 90
> kHz-Timestamp: 15:54:36.9480]
> >          ==> PTS: 5154928921 (0x13341f919)  [= 90
> kHz-Timestamp: 15:54:36.9880]
> 
> Are those PES headers from audio or from video?  Noticed
> the hop here?

Both, and yes.  I vaguely recall some years ago using something
which gave more info about the timestamps, but I cannot for the
life of me remember what, or how.  For the above, I simply `grep'ed
on `Timestamp' and lost the context, sorry.

Anyway, let me give more detail from this PS file, using dvbsnoop,
to put the times I quoted into context.  My point was that I was
seeing the very same timestamps as in the original TS file, while
with `replex', these timestamps were lost.

Whether `replex' preserved the relative offset between video and
audio, I'd have to either create a new stream and compare, or find
the original from which I converted to the replexed files.

Back to the output from `ts2ps':


Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 5154932522 (0x13342072a)  [= 90 kHz-Timestamp: 15:54:37.0280]
             ==> DTS: 5154921721 (0x13341dcf9)  [= 90 kHz-Timestamp: 15:54:36.9080]

Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 5154925321 (0x13341eb09)  [= 90 kHz-Timestamp: 15:54:36.9480]

Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 5154928921 (0x13341f919)  [= 90 kHz-Timestamp: 15:54:36.9880]


Stream_id: 186 (0xba)  [= MPEG_pack_start (PS)]
         ==> system_clock_reference_base: 859937348 (0x33419a44)  [= 90 kHz-Timestamp: 2:39:14.8594]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 5154908244 (0x13341a854)  [= 90 kHz-Timestamp: 15:54:36.7582]


Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 5154943322 (0x13342315a)  [= 90 kHz-Timestamp: 15:54:37.1480]
    DTS:
             ==> DTS: 5154932521 (0x133420729)  [= 90 kHz-Timestamp: 15:54:37.0280]

Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 5154936121 (0x133421539)  [= 90 kHz-Timestamp: 15:54:37.0680]


Odd, if in those packets where both PTS and DTS appear, I were
to take what is given for DTS, it fits into the monotonically
increasing +0,0400sec timestamps of PTS elsewhere.

The audio stream has about 1/4 second offset from the video,
as is well-known for such broadcasts, and matches the offset
I see that `mplayer' needs to apply to sync the two.


Now you have me curious, so I'm `dvbsnoop'ing the TS from which
I `ts2ps'ed the above values.  PIDs 5300 and 5301 are resp. the
video, and audio, from which the PS was made.

PID: 5300 (0x14b4)  [= ]
             ==> program_clock_reference: 1546464923192 (0x168107e0e38)  [= PCR-Timestamp: 15:54:36.478636]

PID: 5300 (0x14b4)  [= ]
             ==> program_clock_reference: 1546465965095 (0x168108df427)  [= PCR-Timestamp: 15:54:36.517225]

PID: 5300 (0x14b4)  [= ]
             ==> program_clock_reference: 1546467003390 (0x168109dcbfe)  [= PCR-Timestamp: 15:54:36.555681]
and on it goes.

Now, getting the payload from the relevant PIDs:

    TS sub-decoding (69 packet(s) stored for PID 0x14b4):
    =====================================================
    TS contains PES/PS stream...
        Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC
11172-2 video stream]
                   ==> PTS: 5154907321 (0x13341a4b9)  [= 90 kHz-Timestamp: 15:54:36.7480]

    TS sub-decoding (145 packet(s) stored for PID 0x14b4):
    =====================================================
    TS contains PES/PS stream...
        Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC
11172-2 video stream]
                   ==> PTS: 5154921722 (0x13341dcfa)  [= 90 kHz-Timestamp: 15:54:36.9080]
                   ==> DTS: 5154910921 (0x13341b2c9)  [= 90 kHz-Timestamp: 15:54:36.7880]

Somewhat further in the stream, we then reach the values given
above for my converted PS file:

    TS sub-decoding (290 packet(s) stored for PID 0x14b4):
    =====================================================
    TS contains PES/PS stream...
        Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC
11172-2 video stream]
                   ==> PTS: 5154932522 (0x13342072a)  [= 90 kHz-Timestamp: 15:54:37.0280]
                   ==> DTS: 5154921721 (0x13341dcf9)  [= 90 kHz-Timestamp: 15:54:36.9080]

    TS sub-decoding (68 packet(s) stored for PID 0x14b4):
    =====================================================
    TS contains PES/PS stream...
        Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC
11172-2 video stream]
                   ==> PTS: 5154925321 (0x13341eb09)  [= 90 kHz-Timestamp: 15:54:36.9480]


That matches precisely the values in the PS file, including the
discrepancy between PTS and DTS that I find curious.


> >      ==> system_clock_reference_base: 859937348
> (0x33419a44)  [= 90 kHz-Timestamp: 2:39:14.8594]
> 
> PS pack header again? Hop backwards from previous pack
> header?

Appears with context above, just before the PTS of the audio PID.
As noted, there's an offset in realtime between the video and audio
timestamps.

> >          ==> PTS: 5154908244 (0x13341a854)  [= 90
> kHz-Timestamp: 15:54:36.7582]

And that's the audio PID.  The video follows.

> >          ==> PTS: 5154943322 (0x13342315a)  [= 90
> kHz-Timestamp: 15:54:37.1480]
> >          ==> DTS: 5154932521 (0x133420729)  [= 90
> kHz-Timestamp: 15:54:37.0280]
> >          ==> PTS: 5154936121 (0x133421539)  [= 90
> kHz-Timestamp: 15:54:37.0680]
> >          ==> PTS: 5154939721 (0x133422349)  [= 90
> kHz-Timestamp: 15:54:37.1080]
> >          ==> PTS: 5154954122 (0x133425b8a)  [= 90
> kHz-Timestamp: 15:54:37.2680]
> 
> Again hops.  Have you tried to play this stream with vlc?

Not yet.  Normally I use `mplayer', with the problem that none of
my machines are fast enough to playback such a stream without me
needing to `-framedrop', and thus, the A-V offset tends to jump
around noticeably, and video/audio sync never quite reaches the
point where any lack of sync in the source would be noticeable.

I'll give it a try (means firing up X and learning options to
vlc to make it play reasonably well on a machine at 100% load)



> BTW: what is the DTS good for?  Isn't PTS the relevant
> time for playbacK?

I'll let someone who actually knows answer, rather than speculating
in ignorance.  I also thought PTS was all to be concerned with for
non-realtime playback, so that the additional wealth of timestamps
weren't too important for a stream written for later playback, but
honestly, I have no clue.


>      And what is the SCRB good for?  I am totally confused
> by all those times.

I'm with you.  I would guess many of the timestamps are used so that
realtime decoders will tend to present the decoded streams in sync
with one another, avoiding echo effects when unsynced devices in the
same room with different sized buffering and different delays in the
decoding process receive the same signal, though in reality, I've
observed devices that are noticeably out-of-sync on the same channel.



Now here's what gets interesting.  I'm accustomed to seeing on the
order of 1/4 second, more or less depending on station, offset in
real time between audio and video timestamps in TSen.

But now that I look more closely at the Shaun data, converted from
BBC One which should have timing data like the BBC Four data above,
I see something unexpected:

Stream_id: 186 (0xba)  [= MPEG_pack_start (PS)]
         ==> system_clock_reference_base: 0 (0x00000000)  [= 90 kHz-Timestamp: 0:00:00.0000]

Stream_id: 186 (0xba)  [= MPEG_pack_start (PS)]
         ==> system_clock_reference_base: 146 (0x00000092)  [= 90 kHz-Timestamp: 0:00:00.0016]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 16200 (0x00003f48)  [= 90 kHz-Timestamp: 0:00:00.1800]

Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 23400 (0x00005b68)  [= 90 kHz-Timestamp: 0:00:00.2600]
             ==> DTS: 12600 (0x00003138)  [= 90 kHz-Timestamp: 0:00:00.1400]

and plenty of system_clock_reference_base

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 22680 (0x00005898)  [= 90 kHz-Timestamp: 0:00:00.2520]

Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 66600 (0x00010428)  [= 90 kHz-Timestamp: 0:00:00.7400]
             ==> DTS: 55800 (0x0000d9f8)  [= 90 kHz-Timestamp: 0:00:00.6200]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 29160 (0x000071e8)  [= 90 kHz-Timestamp: 0:00:00.3240]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 33480 (0x000082c8)  [= 90 kHz-Timestamp: 0:00:00.3720]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 39960 (0x00009c18)  [= 90 kHz-Timestamp: 0:00:00.4440]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 46440 (0x0000b568)  [= 90 kHz-Timestamp: 0:00:00.5160]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 50760 (0x0000c648)  [= 90 kHz-Timestamp: 0:00:00.5640]

snippage...

         ==> system_clock_reference_base: 51950 (0x0000caee)  [= 90 kHz-Timestamp: 0:00:00.5772]

Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2
video stream]
             ==> PTS: 109800 (0x0001ace8)  [= 90 kHz-Timestamp: 0:00:01.2200]
             ==> DTS: 99000 (0x000182b8)  [= 90 kHz-Timestamp: 0:00:01.1000]

Stream_id: 192 (0xc0)  [= ISO/IEC 13818-3 or ISO/IEC 11172-3 audio stream]
             ==> PTS: 63720 (0x0000f8e8)  [= 90 kHz-Timestamp: 0:00:00.7080]


Things I find interesting:
The PTS (DTS?) offsets between the video and audio are closer to
half a second.  I'd really have to dig to find where I archived
the original TS recording.

At the start, first audio then video packets with nearly the same
PTS appear, in spite of the source being different, before the
values approach that expected, meaning there's not a one-to-one
transfer of info from the source to the PS, by some manner.

Video timestamps here only appear as combined PTS/DTS; there are
plenty of SCRB timestamps between everything.

That `replex' file was created with a `dvd' option; the file where
I tried the `mpeg2' option is similarly interesting, with a few
scattered PTS-only video timestamps, while most of the combined
PTS-DTS packets have identical values for both, and which do not
match the PTS-only timestamps (without pasting, I see PTS-only
timestamp at 1,58sec, followed later by PTS+DTS timestamps 1,50
sec, and later audio PTS at 1,07sec, and SCRB at 1,00sec).

It's all very confusing, you see.  Both files played on the DVD
player, as I remember, without obvious problems, though I can't
remember if there was strangeness at the start -- as I was aware
of the realtime offset between audio and video within the file, I
wondered how the DVD player would cope.

And now, I'm wondering just how `replex' is arriving at these
timestamps from the TS file.


Anyway, it's not all that relevant, no?  I'm just muttering to
myself out loud, yes?  I'm not slowly going insane, right?

I'll be off in my corner, rocking back and forth

Yours &c, &c,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
