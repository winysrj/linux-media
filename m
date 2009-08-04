Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:43804 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbZHDOTQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Aug 2009 10:19:16 -0400
Date: Tue, 4 Aug 2009 16:19:05 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: olgrenie@dibcom.fr
Subject: Re: RFC: adding ISDB-T/ISDB-Tsb to DVB-API 5
In-Reply-To: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de>
Message-ID: <alpine.LRH.1.10.0908041617050.8512@pub1.ifh.de>
References: <alpine.LRH.1.10.0908031943220.8512@pub1.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

I updated some things in the document, please use the following for your 
comments:

Version 1.2 - 2009-08-04
========================

Changelog
=========

v1.2 - 2009-08-04
- removed DTV_BANDWIDTH from being a necessary parameter - now optional

v1.1 - 2009-08-04
- added DTV_FREQUENCY as a necessary parameter

v1.0 - 2009-08-03
- initial draft

Proposal
========

This document describes shortly what are the possible parameters in the Linux
DVB-API called "S2API" and now DVB API 5 in order to tune an ISDB-T/ISDB-Tsb
demodulator:

This ISDB-T/ISDB-Tsb API extension should reflect all information
needed to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible
that some very sophisticated devices won't need certain parameters to
tune.

The information given here should help application writers to know how
to handle ISDB-T and ISDB-Tsb hardware using the Linux DVB-API.

The details given here about ISDB-T and ISDB-Tsb are just enough to basically
show the dependencies between the needed parameter values, but surely some
information is left out. For more detailed information see the standard document:
ARIB STD-B31 - "Transmission System for Digital Terrestrial Television
Broadcasting".

In order to read this document one has to know about the channel
structure in ISDB-T and ISDB-Tsb. I.e. it has to be known to the
reader that an ISDB-T channel consists of 13 segments, that it can
have up to 3 layer sharing those segments, and so on.

Parameters used by ISDB-T and ISDB-Tsb.

Existing parameters
===================

a) DTV_FREQUENCY

Central frequency of the channel.

For ISDB-T the channels are usally transmitted with an offset of 143kHz. E.g. a
valid frequncy could be 474143 kHz. The stepping is bound to the bandwidth of
the channel which is 6MHz.

As in ISDB-Tsb the channel consists of only one or three segments the
frequency step is 429kHz, 3*429 respectively. As for ISDB-T the
central frequency of the channel is expected.

b) DTV_BANDWIDTH_HZ (optional)

Possible values:

For ISDB-T it should be always 6000000Hz (6MHz)
For ISDB-Tsb it can vary depending on the number of connected segments

Note: Hardware specific values might be given here, but standard
applications should not bother to set a value to this field as
standard demods are ignoring it anyway.

Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
DTV_ISDBT_SB_SEGMENT_COUNT).

c) DTV_DELIVERY_SYSTEM

Possible values: SYS_ISDBT

d) DTV_TRANSMISSION_MODE

ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K

Possible values: TRANSMISSION_MODE_2K, TRANSMISSION_MODE_8K,
 	 TRANSMISSION_MODE_AUTO, TRANSMISSION_MODE_4K

If DTV_TRANSMISSION_MODE is set the TRANSMISSION_MODE_AUTO the
hardware will try to find the correct FFT-size (if capable) and will
use TMCC to fill in the missing parameters.

TRANSMISSION_MODE_4K is added at the same time as the other new parameters.

e) DTV_GUARD_INTERVAL

Possible values: GUARD_INTERVAL_1_32, GUARD_INTERVAL_1_16, GUARD_INTERVAL_1_8,
 	 GUARD_INTERVAL_1_4, GUARD_INTERVAL_AUTO

If DTV_GUARD_INTERVAL is set the GUARD_INTERVAL_AUTO the hardware will
try to find the correct guard interval (if capable) and will use TMCC to fill
in the missing parameters.

New parameters
==============

1. DTV_ISDBT_PARTIAL_RECEPTION (1b)

If DTV_ISDBT_SOUND_BROADCASTING is '0' this bit-field represents whether
the channel is in partial reception mode or not.

If '1' DTV_ISDBT_LAYERA_* values are assigned to the center segment and
DTV_ISDBT_LAYERA_SEGMENT_COUNT has to be '1'.

If in addition DTV_ISDBT_SOUND_BROADCASTING is '1'
DTV_ISDBT_PARTIAL_RECEPTION represents whether this ISDB-Tsb channel
is consisting of one segment and layer or three segments and two layers.

Possible values: 0, 1, -1 (AUTO)

2. DTV_ISDBT_SOUND_BROADCASTING (1b)

This field represents whether the other DTV_ISDBT_*-parameters are
referring to an ISDB-T and an ISDB-Tsb channel. (See also
DTV_ISDBT_PARTIAL_RECEPTION).

Possible values: 0, 1, -1 (AUTO)

3. DTV_ISDBT_SB_SUBCHANNEL_ID

This field only applies if DTV_ISDBT_SOUND_BROADCASTING is '1'.

(Note of the author: This might not be the correct description of the
  SUBCHANNEL-ID in all details, but it is my understanding of the technical
  background needed to program a device)

An ISDB-Tsb channel (1 or 3 segments) can be broadcasted alone or in a
set of connected ISDB-Tsb channels. In this set of channels every
channel can be received independently. The number of connected
ISDB-Tsb segment can vary, e.g. depending on the frequency spectrum
bandwidth available.

Example: Assume 8 ISDB-Tsb connected segments are broadcasted. The
broadcaster has several possibilities to put those channels in the
air: Assuming a normal 13-segment ISDB-T spectrum he can align the 8
segments from position 1-8 to 5-13 or anything in between.

The underlying layer of segments are subchannels: each segment is
consisting of several subchannels with a predefined IDs. A sub-channel
is used to help the demodulator to synchronize on the channel.

An ISDB-T channel is always centered over all sub-channels. As for
the example above, in ISDB-Tsb it is no longer as simple as that.

The DTV_ISDBT_SB_SUBCHANNEL_ID parameter is used to give the
sub-channel ID of the segment to be demodulated.

Possible values: 0 .. 41, -1 (AUTO)

4. DTV_ISDBT_SB_SEGMENT_IDX

This field only applies if DTV_ISDBT_SOUND_BROADCASTING is '1'.

DTV_ISDBT_SB_SEGMENT_IDX gives the index of the segment to be
demodulated for an ISDB-Tsb channel where several of them are
transmitted in the connected manner.

Possible values: 0 .. DTV_ISDBT_SB_SEGMENT_COUNT-1

Note: This value cannot be determined by an automatic channel search.

5. DTV_ISDBT_SB_SEGMENT_COUNT

This field only applies if DTV_ISDBT_SOUND_BROADCASTING is '1'.

DTV_ISDBT_SB_SEGMENT_COUNT gives the total count of connected ISDB-Tsb
channels.

Possible values: 1 .. 13

Note: This value cannot be determined by an automatic channel search.

6. Hierarchical layers

ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
ISDB-T hierarchical layers can be decoded simultaneously. For that
reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.

ISDB-T has 3 hierarchical layers which each can use a part of the
available segments. The total number of segments over all layers has
to 13 in ISDB-T.

6.1 DTV_ISDBT_LAYER_ENABLED (3b)

Hierarchical reception in ISDB-T is achieved by enabling or disabling
layers in the decoding process. Setting all bits of
DTV_ISDBT_LAYER_ENABLED to '1' forces all layers (if applicable) to be
demodulated. This is the default.

If the channel is in the partial reception mode
(DTV_ISDBT_PARTIAL_RECEPTION=1) the central segment can be decoded
independently of the other 12 segments. In that mode layer A has to
have a SEGMENT_COUNT of 1.

In ISDB-Tsb only layer A is used, it can be 1 or 3 in ISDB-Tsb
according to DTV_ISDBT_PARTIAL_RECEPTION. SEGMENT_COUNT must be filled
accordingly.

Possible values: 0x1, 0x2, 0x4 (|-able)

DTV_ISDBT_LAYER_ENABLED[0:0] - layer A
DTV_ISDBT_LAYER_ENABLED[1:1] - layer B
DTV_ISDBT_LAYER_ENABLED[2:2] - layer C
DTV_ISDBT_LAYER_ENABLED[31:3] unused

6.2 DTV_ISDBT_LAYER*_FEC

Possible values: FEC_AUTO, FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8,

6.3 DTV_ISDBT_LAYER*_MODULATION

Possible values: QAM_AUTO, QPSK, QAM_16, QAM_64, DQPSK

Note: If layer C is DQPSK layer B has to be DQPSK. If layer B is DQPSK
and DTV_ISDBT_PARTIAL_RECEPTION=0 layer has to be DQPSK.

6.4 DTV_ISDBT_LAYER*_SEGMENT_COUNT

Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)

Note: Truth table for DTV_ISDBT_SOUND_BROADCASTING and
DTV_ISDBT_PARTIAL_RECEPTION and LAYER*_SEGMENT_COUNT

  PR | SB || layer A width | layer B width | layer C width | total
----+----++---------------+---------------+---------------+-------
   0 |  0 || 1 .. 13       | 1 .. 13       | 1..13         | 13
   1 |  0 || 1             | 1 .. 13       | 1..13         | 13
   0 |  1 || 1             | 0             | 0             | 1
   1 |  1 || 1             | 2             | 0             | 3


6.5 DTV_ISDBT_LAYER*_TIME_INTERLEAVING

Possible values: 0, 1, 2, 3, -1 (AUTO)

Note: The real inter-leaver depth-names depend on the mode (fft-size); the values
here are referring to what can be found in the TMCC-structure -
independent of the mode.


On Mon, 3 Aug 2009, Patrick Boettcher wrote:

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
> (DTV_CMDs) for ISDB-T(sb) and how to use them. I'm inlining this document, as 
> it is the base for the RFC as well:
>
> [..]
