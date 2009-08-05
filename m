Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64322 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZHETv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 15:51:27 -0400
Received: by ewy10 with SMTP id 10so262420ewy.37
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 12:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de>
References: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de>
Date: Wed, 5 Aug 2009 15:51:25 -0400
Message-ID: <37219a840908051251g1ec47b6dx1d940862727a9c46@mail.gmail.com>
Subject: Re: RFC: adding ISDB-T/ISDB-Tsb to DVB-API 5
From: Michael Krufky <mkrufky@kernellabs.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	olgrenie@dibcom.fr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 3, 2009 at 1:53 PM, Patrick
Boettcher<patrick.boettcher@desy.de> wrote:
> Hi all,
>
> I'd like to request some comments about the extension of the DVB-API 5 to
> support ISDB-T and ISDB-Tsb. Some stubs in frontend.h and friends have been
> there since the beginning and now it's time to have real user-space support
> for that standard.
>
> I hope that we can finish the discussion of this RFC before the merge window
> of 2.6.32, so that it can be included then.
>
> The current version of the patches can be found here:
>
> http://linuxtv.org/hg/~pb/v4l-dvb/rev/eabb8cfcf32a
>
> Changelog:
> This patch increments the DVB-API to version 5.1 in order to reflect the
> addition of ISDB-T and ISDB-Tsb on Linux' DVB-API.
>
> Changes in detail:
> - added a small document to describe how to use the API to tune to an ISDB-T
> or ISDB-Tsb channel
> - added necessary fields to dtv_frontend_cache
> - added a smarter clear-cache function which resets all fields of the
> dtv_frontend_cache
> - added a TRANSMISSION_MODE_4K to fe_transmit_mode_t
>
> I also added a document trying to descibe in short all the needed parameters
> (DTV_CMDs) for ISDB-T(sb) and how to use them. I'm inlining this document,
> as it is the base for the RFC as well:
>
> (Disclaimer: ISDB-T and ISDB-Tsb is relative complex from the parameters
> point of view compared to DVB-T and for me the standard-document was not
> making things very easy for me as a software-writer. Please don't blame me
> for so many additions)
>
> -----------------
> This document describes shortly what are the possible parameters in
> the Linux DVB-API called "S2API" in order to tune an ISDB-T/ISDB-Tsb
> demodulator:
>
> This ISDB-T/ISDB-Tsb API extension should reflect all information
> needed to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible
> that some very sophisticated devices won't need certain parameters to
> tune.
>
> The information given here should help application writers to know how
> to handle ISDB-T and ISDB-Tsb hardware using the Linux DVB-API.
>
> The details given here about ISDB-T and ISDB-Tsb are just enough to
> basically
> show the dependencies between the needed parameter values, but surely some
> information is left out. For more detailed information see the standard
> document:
> ARIB STD-B31 - "Transmission System for Digital Terrestrial Television
> Broadcasting".
>
> In order to read this document one has to know about the channel
> structure in ISDB-T and ISDB-Tsb. I.e. it has to be known to the
> reader that an ISDB-T channel consists of 13 segments, that it can
> have up to 3 layer sharing those segments, and so on.
>
> Parameters used by ISDB-T and ISDB-Tsb.
>
> Existing parameters
> ===================
>
> a) DTV_BANDCOUNT_HZ
>
> Help the front-end, for example, to set up base-band-filters.
>
> Possible values:
>
> For ISDB-T it should be always 6000000Hz (6MHz)
> For ISDB-Tsb it can vary depending on the number of connected segments
>
> b) DTV_DELIVERY_SYSTEM
>
> Possible values: SYS_ISDBT
>
> c) DTV_TRANSMISSION_MODE
>
> ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
> 'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K
>
> Possible values: TRANSMISSION_MODE_2K, TRANSMISSION_MODE_8K,
>         TRANSMISSION_MODE_AUTO, TRANSMISSION_MODE_4K
>
> If DTV_TRANSMISSION_MODE is set the TRANSMISSION_MODE_AUTO the
> hardware will try to find the correct FFT-size (if capable) and use
> the TMCC to fill in the missing parameters.
>
> TRANSMISSION_MODE_4K is added at the same time as the other new parameters.
>
> d) DTV_GUARD_INTERVAL
>
> Possible values: GUARD_INTERVAL_1_32, GUARD_INTERVAL_1_16,
> GUARD_INTERVAL_1_8,
>         GUARD_INTERVAL_1_4, GUARD_INTERVAL_AUTO
>
> If DTV_GUARD_INTERVAL is set the GUARD_INTERVAL_AUTO the hardware will
> try to find the correct guard interval (if capable) and use the TMCC to fill
> in the missing parameters.
>
> New parameters
> ==============
>
> 1. DTV_ISDBT_PARTIAL_RECEPTION (1b)
>
> If DTV_ISDBT_SOUND_BROADCASTING is '0' this bit-field represents whether
> the channel is in partial reception mode or not.
>
> If '1' DTV_ISDBT_LAYERA_* values are assigned to the center segment and
> DTV_ISDBT_LAYERA_SEGMENT_COUNT has to be '1'.
>
> If in addition DTV_ISDBT_SOUND_BROADCASTING is '1'
> DTV_ISDBT_PARTIAL_RECEPTION represents whether this ISDB-Tsb channel
> is consisting of one segment and layer or three segments and two layers.
>
> Possible values: 0, 1, -1 (AUTO)
>
> 2. DTV_ISDBT_SOUND_BROADCASTING (1b)
>
> This field represents whether the other DTV_ISDBT_*-parameters are
> referring to an ISDB-T and an ISDB-Tsb channel. (See also
> DTV_ISDBT_PARTIAL_RECEPTION).
>
> Possible values: 0, 1, -1 (AUTO)
>
> 3. DTV_ISDBT_SB_SUBCHANNEL_ID
>
> This field only applies if DTV_ISDBT_SOUND_BROADCASTING is '1'.
>
> (Note of the author: This might not be the correct description of the
>  SUBCHANNEL-ID in all details, but it is my understanding of the technical
>  background needed to program a device)
>
> An ISDB-Tsb channel (1 or 3 segments) can be broadcasted alone or in a
> set of connected ISDB-Tsb channels. In this set of channels every
> channel can be received independently. The number of connected
> ISDB-Tsb segment can vary, e.g. depending on the frequency spectrum
> bandwidth available.
>
> Example: Assume 8 ISDB-Tsb connected segments are broadcasted. The
> broadcaster has several possibilities to put those channels in the
> air: Assuming a normal 13-segment ISDB-T spectrum he can align the 8
> segments from position 1-8 to 5-13 or anything in between.
>
> The underlying layer of segments are subchannels: each segment is
> consisting of several subchannels with a predefined IDs. A sub-channel
> is used to help the demodulator to synchronize on the channel.
>
> An ISDB-T channel is always centered over all sub-channels. As for
> the example above, in ISDB-Tsb it is no longer as simple as that.
>
> The DTV_ISDBT_SB_SUBCHANNEL_ID parameter is used to give the
> sub-channel ID of the segment to be demodulated.
>
> Possible values: 0 .. 41, -1 (AUTO)
>
> 4. DTV_ISDBT_SB_SEGMENT_IDX
>
> This field only applies if DTV_ISDBT_SOUND_BROADCASTING is '1'.
>
> DTV_ISDBT_SB_SEGMENT_IDX gives the index of the segment to be
> demodulated for an ISDB-Tsb channel where several of them are
> transmitted in the connected manner.
>
> Possible values: 0 .. DTV_ISDBT_SB_SEGMENT_COUNT-1
>
> Note: This value cannot be determined by an automatic channel search.
>
> 5. DTV_ISDBT_SB_SEGMENT_COUNT
>
> This field only applies if DTV_ISDBT_SOUND_BROADCASTING is '1'.
>
> DTV_ISDBT_SB_SEGMENT_COUNT gives the total count of connected ISDB-Tsb
> channels.
>
> Possible values: 1 .. 13
>
> Note: This value cannot be determined by an automatic channel search.
>
> 6. Hierarchical layers
>
> ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
> ISDB-T hierarchical layers can be decoded simultaneously. For that
> reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.
>
> ISDB-T has 3 hierarchical layers which each can use a part of the
> available segments. The total number of segments over all layers has
> to 13 in ISDB-T.
>
> 6.1 DTV_ISDBT_LAYER_ENABLED (3b)
>
> Hierarchical reception in ISDB-T is achieved by enabling or disabling
> layers in the decoding process. Setting all bits of
> DTV_ISDBT_LAYER_ENABLED to '1' forces all layers (if applicable) to be
> demodulated. This is the default.
>
> If the channel is in the partial reception mode
> (DTV_ISDBT_PARTIAL_RECEPTION=1) the central segment can be decoded
> independently of the other 12 segments. In that mode layer A has to
> have a SEGMENT_COUNT of 1.
>
> In ISDB-Tsb only layer A is used, it can be 1 or 3 in ISDB-Tsb
> according to DTV_ISDBT_PARTIAL_RECEPTION. SEGMENT_COUNT must be filled
> accordingly.
>
> Possible values: 0x1, 0x2, 0x4 (|-able)
>
> DTV_ISDBT_LAYER_ENABLED[0:0] - layer A
> DTV_ISDBT_LAYER_ENABLED[1:1] - layer B
> DTV_ISDBT_LAYER_ENABLED[2:2] - layer C
> DTV_ISDBT_LAYER_ENABLED[31:3] unused
>
> 6.2 DTV_ISDBT_LAYER*_FEC
>
> Possible values: FEC_AUTO, FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8,
>
> 6.3 DTV_ISDBT_LAYER*_MODULATION
>
> Possible values: QAM_AUTO, DQPSK, QAM_16, QAM_64, DQPSK
>
> Note: If layer C is DQPSK layer B has to be DQPSK. If layer B is DQPSK
> and DTV_ISDBT_PARTIAL_RECEPTION=0 layer has to be DQPSK.
>
> 6.4 DTV_ISDBT_LAYER*_SEGMENT_COUNT
>
> Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)
>
> Note: Truth table for DTV_ISDBT_SOUND_BROADCASTING and
> DTV_ISDBT_PARTIAL_RECEPTION and LAYER*_SEGMENT_COUNT
>
>  PR | SB || layer A width | layer B width | layer C width | total
> ----+----++---------------+---------------+---------------+-------
>  0 |  0 || 1 .. 13       | 1 .. 13       | 1..13         | 13
>  1 |  0 || 1             | 1 .. 13       | 1..13         | 13
>  0 |  1 || 1             | 0             | 0             | 1
>  1 |  1 || 1             | 2             | 0             | 3
>
>
> 6.5 DTV_ISDBT_LAYER*_TIME_INTERLEAVING
>
> Possible values: 0, 1, 2, 3, -1 (AUTO)
>
> Note: The real inter-leaver depth-names depend on the mode (fft-size); the
> values
> here are referring to what can be found in the TMCC-structure -
> independent of the mode.
>
> -----------------
>
>
> thanks for the feedback in advance,
> Patrick.

Patrick,

It's extremely exciting to finally see this surfacing to the mailing
lists -- It will be a great addition to linux-dvb to have support for
the ISDB digital standards.

One thing that I see missing right now is userspace utilities.  Do you
have any plans to add ISDB scanning support to dvb-apps, and tuning
support to the *zap utility?  This would be the best way to get the
application developers started on incorporating ISDB support into the
apps shipping today.

Regards,

Mike
