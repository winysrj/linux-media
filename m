Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1FIBUq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 21:20:46 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p591Kk3d003802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 21:20:46 -0400
Received: from [10.11.10.126] (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p591Kien013677
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 21:20:45 -0400
Message-ID: <4DF01FEB.4050205@redhat.com>
Date: Wed, 08 Jun 2011 22:20:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC] Media kernelspace-userspace API specs (V4L/DVB/IR) - Was: Re:
 [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
References: <20110608172311.0d350ab7@pedra>
In-Reply-To: <20110608172311.0d350ab7@pedra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Em 08-06-2011 17:23, Mauro Carvalho Chehab escreveu:
> There's a huge gap between the DVB specs and the current implementation.
> This were caused by years of changes that happened at the code but
> no updates to the specs were done.
> 
> This patch series tries to reduce this gap.
> 
> Basically, the headers at include/linux/dvb were included at the API.
> The Makefile scripting auto-generate references for structs, typedefs
> and ioctls. With this, it is now easy to identify when something is
> missing.
> 
> After adding such logic, I've manually synchronized the specs with the
> header file and updated the data structures.
> 
> The work is not complete yet: there are still several ioctl's not
> documented at the specs:
> 
> Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
> Error: no ID for constraint linkend: CA_RESET.
> Error: no ID for constraint linkend: CA_GET_CAP.
> Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
> Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
> Error: no ID for constraint linkend: CA_GET_MSG.
> Error: no ID for constraint linkend: CA_SEND_MSG.
> Error: no ID for constraint linkend: CA_SET_DESCR.
> Error: no ID for constraint linkend: CA_SET_PID.
> Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
> Error: no ID for constraint linkend: DMX_GET_CAPS.
> Error: no ID for constraint linkend: DMX_SET_SOURCE.
> Error: no ID for constraint linkend: DMX_ADD_PID.
> Error: no ID for constraint linkend: DMX_REMOVE_PID.
> Error: no ID for constraint linkend: NET_ADD_IF.
> Error: no ID for constraint linkend: NET_REMOVE_IF.
> Error: no ID for constraint linkend: NET_GET_IF.
> Error: no ID for constraint linkend: VIDEO_GET_SIZE.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
> Error: no ID for constraint linkend: VIDEO_GET_PTS.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
> Error: no ID for constraint linkend: VIDEO_COMMAND.
> Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.
> 
> I also opted to not add the osd.h header into the DocBook, as it seemed
> odd on my eyes, and it is used only by one legacy hardware.
> 
> While here, I noticed that one audio ioctl is not used anyware
> (AUDIO_GET_PTS). There is just the ioctl definition and that's it. 
> I just removed this definition, as removing it won't cause any 
> regression, as no in-kernel driver or dvb-core uses it.
> 
> Btw, there are several ioctl's and correponding data structures that
> are used on just one or two old drivers. I think we should consider
> to deprecate those old stuff.
> 
> Mauro Carvalho Chehab (13):
>   [media] DocBook: Add the other DVB API header files
>   [media] DocBook/audio.xml: match section ID's with the reference links
>   [media] DocBook/audio.xml: synchronize attribute changes
>   [media] DocBook: Document AUDIO_CONTINUE ioctl
>   [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
>   [media] Docbook/ca.xml: match section ID's with the reference links
>   [media] DocBook/ca.xml: Describe structure ca_pid
>   [media] DocBook/demux.xml: Fix section references with dmx.h.xml
>   [media] DocBook/demux.xml: Add the remaining data structures to the API spec
>   [media] DocBook/net.xml: Synchronize Network data structure
>   [media] DocBook/Makefile: Remove osd.h header
>   [media] DocBook/video.xml: Fix section references with video.h.xml
>   [media] DocBook/video.xml: Document the remaining data structures

1) INTRODUTION
   ===========

Over the last few days, I did a big effort to identify the gaps between
the code implementation and the media documentation. 

As most of you know, our API's are documented since some time inside the
Linux Kernel tree. However, unfortunately, developers sometimes add
improvements at the drivers without taking enough care of documenting
the changes at the API specs.

The gap at V4L side were solved several years ago, when we've added the
V4L DocBook specs inside the mercurial tree and added some Makefile
and DocBook "magic" to allow discovering that some information were missing[1].
Of course, the logic is not perfect, as it doesn't validate the quality
of the documentation.

For DVB, the situation were worse: while in Kernel, all specs are at DocBook
format (and, thankfully, V4L were already using DocBook), DVB were using
latex format. Worse than that, except for the original writers, the other
DVB developers didn't have the habit to update. So, while the DVB API were
in version 3, the specs were in version 1.

A few years ago, I've ported the DVB docs to DocBook format, migrated the
V4L DocBook format to the one used inside the Kernel, merged both and added
some documentation about IR. The end result is the Media API DocBook:

	http://linuxtv.org/downloads/v4l-dvb-apis/

Due to the differences between DVB and V4L formats, I broke it into two
divisions: one for V4L and one for DVB. Later, the Remote Controller and
the Media Controller divisions were added.

Yet, the DVB documentation were still at version 1. With ISDB-T support,
the specs for version 5 were added. A few other updates were added there,
from time to time, but no major efforts of really updating it to v5 were
done.

Well, Over the last few days, I did a big effort to identify the gaps between
the code implementation and the media documentation, at the DVB side.

-
[1] Basically, the Makefile auto-generate indexes for the data types and
ioctl's. Cross-references between the header files and the specs warrants
that everything is documented, otherwise, an error is generated.


2) CURRENT STATUS
   ==============

After the last day patches, the end result of is that:

	- API gaps on both V4L and DVB parts are now shown;

	- The V4L gaps were already fixed;

	- include/linux/osd.h: the API is not documented. I decided to
keep it outside the documentation, as it is being used only by a legacy
driver, and the API violates several Linux CodingStyle rules. I suspect
that we can just deprecate this API, instead of propagating its usage.

	- 100% of the DVB data structures are now documented;

	- there are 22 DVB ioctl's not documented at the API (excluding
	  the osd ones), from the total amount of 111 ioctl's. So, about
	  20% of the ioctl's are not documented yet.

	- the API specs contain several IOCTL's and data structures
that are used only by one or two old drivers, without any recent
driver needing to use them;

	- there are some overlap area between DVB Video/Audio API's and V4L API;

	- there are some overlap area between DVB Audio API and ALSA API;

	- there are still some gaps at the Remote Controller API. Basically, 
	  the sysfs nodes are not documented yet;

	- currently, there's no Makefile "magic" to double check discrepancies
	  at the Remote Controller and at the Media Controller API's.

3) PROPOSALS
   =========

A badly documented API is something very bad, as:

- userspace developers need to figure out how the driver and core works in
  order to write their code. Worse than that, if a driver has a bug and is
  doing something wrong, the userspace developer may assume that the broken
 behavior is the correct one. So, a latter fix at the driver will break the
 userspace application;

- kernelspace developers may have different opinions about how to implement
  some feature, leading into different, incompatible implementations.

So, we need to be sure that the API is properly documenting what's the expected 
behavior, otherwise the specs are useless.

I got some interesting statistics at the annex part of this RFC. Based on that,
I propose to:

a) Put a notice at the specs that the AUDIO, VIDEO and OSD ioctl's
   are deprecated and shouldn't be used on newer drivers.
   We don't need to remove them from the drivers, but, at least on
   ivtv, we should expand the V4L/ALSA support if needed, in order
   to implement what's missed there.

b) Better analyse the following CA ioctls:
	CA_GET_DESCR_INFO, CA_SET_DESCR (used on bt8xx/dst_ca and av7110_ca);
	CA_SET_PID (used only on bt8xx/dst_ca.c).
As they're implemented only inside two drivers. Maybe they should also be
supported by the dvb core (dvb_ca_en50221.c). None of the above are
documented.

c) Document the ioctl's bellow, as they are used inside the core:
	CA_RESET
	CA_GET_CAP
	CA_GET_SLOT_INFO
	CA_GET_MSG
	CA_SEND_MSG
	DMX_GET_PES_PIDS
	DMX_GET_CAPS
	DMX_SET_SOURCE
	DMX_ADD_PID
	DMX_REMOVE_PID
	NET_ADD_IF
	NET_REMOVE_IF
	NET_GET_IF

d) Marking the removal of the legacy NET ioctls (__NET_ADD_IF_OLD, __NET_GET_IF_OLD)
   at Documentation/feature-removal-schedule.txt for its removal on 3.2.

e) Document the Remote Controller sysfs nodes;

f) Add some logic to compare the API's implemented for RC and Media Controller with
   the *.h files.

Comments?

---


ANNEX) SOME STATISTICS
======================


a) The complete list of ioctl's can be obtained by this small shell script:

$ perl -ne 'print "$1\n" if /\#define\s+([^\s]+)\s+_IO/' include/linux/dvb/*

b) Combining it with git grep, it is clear that there are only 41 ioctl's that
   are implemented inside the DVB core:

$ for i in $(perl -ne 'print "$1\n" if /\#define\s+([^\s]+)\s+_IO/' include/linux/dvb/*); do if [ "$(git grep -l $i drivers/media/dvb/dvb-core/)" != "" ]; then echo $i; fi ; done |wc -l
41

Those ioctl's are:

$ for i in $(perl -ne 'print "$1\n" if /\#define\s+([^\s]+)\s+_IO/' include/linux/dvb/*); do if [ "$(git grep -l $i drivers/media/dvb/dvb-core/)" != "" ]; then echo $i; fi ; done
CA_RESET
CA_GET_CAP
CA_GET_SLOT_INFO
CA_GET_MSG
CA_SEND_MSG
DMX_START
DMX_STOP
DMX_SET_FILTER
DMX_SET_PES_FILTER
DMX_SET_BUFFER_SIZE
DMX_GET_PES_PIDS
DMX_GET_CAPS
DMX_SET_SOURCE
DMX_GET_STC
DMX_ADD_PID
DMX_REMOVE_PID
FE_SET_PROPERTY
FE_GET_PROPERTY
FE_GET_INFO
FE_DISEQC_RESET_OVERLOAD
FE_DISEQC_SEND_MASTER_CMD
FE_DISEQC_RECV_SLAVE_REPLY
FE_DISEQC_SEND_BURST
FE_SET_TONE
FE_SET_VOLTAGE
FE_ENABLE_HIGH_LNB_VOLTAGE
FE_READ_STATUS
FE_READ_BER
FE_READ_SIGNAL_STRENGTH
FE_READ_SNR
FE_READ_UNCORRECTED_BLOCKS
FE_SET_FRONTEND
FE_GET_FRONTEND
FE_SET_FRONTEND_TUNE_MODE
FE_GET_EVENT
FE_DISHNETWORK_SEND_LEGACY_CMD
NET_ADD_IF
NET_REMOVE_IF
NET_GET_IF
__NET_ADD_IF_OLD
__NET_GET_IF_OLD

The last two ones are obsolete ioctl's.

c) If we do a grep -v removing the above from the list of the ioctls, we have
   the ioctl's that are implemented only inside the drivers:

AUDIO_STOP
AUDIO_PLAY
AUDIO_PAUSE
AUDIO_CONTINUE
AUDIO_SELECT_SOURCE
AUDIO_SET_MUTE
AUDIO_SET_AV_SYNC
AUDIO_SET_BYPASS_MODE
AUDIO_CLEAR_BUFFER
AUDIO_SET_ID
AUDIO_SET_MIXER
AUDIO_SET_STREAMTYPE
AUDIO_SET_EXT_ID
AUDIO_SET_ATTRIBUTES
AUDIO_SET_KARAOKE
AUDIO_BILINGUAL_CHANNEL_SELECT
AUDIO_STOP
AUDIO_PLAY
AUDIO_PAUSE
AUDIO_CONTINUE
AUDIO_SELECT_SOURCE
AUDIO_SET_MUTE
AUDIO_SET_AV_SYNC
AUDIO_SET_BYPASS_MODE
AUDIO_CHANNEL_SELECT
AUDIO_GET_STATUS
AUDIO_GET_CAPABILITIES
AUDIO_CLEAR_BUFFER
AUDIO_SET_ID
AUDIO_SET_MIXER
AUDIO_SET_STREAMTYPE
AUDIO_SET_EXT_ID
AUDIO_SET_ATTRIBUTES
AUDIO_SET_KARAOKE
AUDIO_BILINGUAL_CHANNEL_SELECT
CA_GET_DESCR_INFO
CA_SET_DESCR
CA_SET_PID
OSD_SEND_CMD
OSD_GET_CAPABILITY
VIDEO_STOP
VIDEO_PLAY
VIDEO_FREEZE
VIDEO_CONTINUE
VIDEO_SELECT_SOURCE
VIDEO_SET_BLANK
VIDEO_GET_STATUS
VIDEO_GET_EVENT
VIDEO_SET_DISPLAY_FORMAT
VIDEO_STILLPICTURE
VIDEO_FAST_FORWARD
VIDEO_SLOWMOTION
VIDEO_GET_CAPABILITIES
VIDEO_CLEAR_BUFFER
VIDEO_SET_ID
VIDEO_SET_STREAMTYPE
VIDEO_SET_FORMAT
VIDEO_SET_SYSTEM
VIDEO_SET_HIGHLIGHT
VIDEO_SET_SPU
VIDEO_SET_SPU_PALETTE
VIDEO_GET_NAVI
VIDEO_SET_ATTRIBUTES
VIDEO_GET_SIZE
VIDEO_GET_FRAME_RATE
VIDEO_GET_PTS
VIDEO_GET_FRAME_COUNT
VIDEO_COMMAND
VIDEO_TRY_COMMAND

d) The API usage inside drivers/media and drivers/staging is given by:

$ for i in $(perl -ne 'print "$1\n" if /\#define\s+([^\s]+)\s+_IO/' include/linux/dvb/*); do echo $i; git grep -l $i drivers/media/ drivers/staging/ ; done
AUDIO_STOP
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_PLAY
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_PAUSE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_CONTINUE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SELECT_SOURCE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_MUTE
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
AUDIO_SET_AV_SYNC
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_BYPASS_MODE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_CHANNEL_SELECT
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
AUDIO_GET_STATUS
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_GET_CAPABILITIES
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_CLEAR_BUFFER
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_ID
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_MIXER
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_STREAMTYPE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_EXT_ID
AUDIO_SET_ATTRIBUTES
AUDIO_SET_KARAOKE
AUDIO_BILINGUAL_CHANNEL_SELECT
drivers/media/video/ivtv/ivtv-ioctl.c
AUDIO_STOP
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_PLAY
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_PAUSE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_CONTINUE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SELECT_SOURCE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_MUTE
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
AUDIO_SET_AV_SYNC
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_BYPASS_MODE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_CHANNEL_SELECT
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
AUDIO_GET_STATUS
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_GET_CAPABILITIES
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_CLEAR_BUFFER
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_ID
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_MIXER
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_STREAMTYPE
drivers/media/dvb/ttpci/av7110_av.c
AUDIO_SET_EXT_ID
AUDIO_SET_ATTRIBUTES
AUDIO_SET_KARAOKE
AUDIO_BILINGUAL_CHANNEL_SELECT
drivers/media/video/ivtv/ivtv-ioctl.c
CA_RESET
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/dvb-core/dvb_ca_en50221.c
drivers/media/dvb/firewire/firedtv-avc.c
drivers/media/dvb/firewire/firedtv-ci.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_GET_CAP
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/dvb-core/dvb_ca_en50221.c
drivers/media/dvb/firewire/firedtv-ci.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_GET_SLOT_INFO
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/dvb-core/dvb_ca_en50221.c
drivers/media/dvb/firewire/firedtv-ci.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_GET_DESCR_INFO
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_GET_MSG
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/dvb-core/dvb_ca_en50221.c
drivers/media/dvb/firewire/firedtv-ci.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_SEND_MSG
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/dvb-core/dvb_ca_en50221.c
drivers/media/dvb/firewire/firedtv-ci.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_SET_DESCR
drivers/media/dvb/bt8xx/dst_ca.c
drivers/media/dvb/ttpci/av7110_ca.c
CA_SET_PID
drivers/media/dvb/bt8xx/dst_ca.c
DMX_START
drivers/media/dvb/dvb-core/dmxdev.c
DMX_STOP
drivers/media/dvb/dvb-core/dmxdev.c
DMX_SET_FILTER
drivers/media/dvb/dvb-core/dmxdev.c
DMX_SET_PES_FILTER
drivers/media/dvb/dvb-core/dmxdev.c
DMX_SET_BUFFER_SIZE
drivers/media/dvb/dvb-core/dmxdev.c
DMX_GET_PES_PIDS
drivers/media/dvb/dvb-core/dmxdev.c
DMX_GET_CAPS
drivers/media/dvb/dvb-core/dmxdev.c
DMX_SET_SOURCE
drivers/media/dvb/dvb-core/dmxdev.c
DMX_GET_STC
drivers/media/dvb/dvb-core/dmxdev.c
DMX_ADD_PID
drivers/media/dvb/dvb-core/dmxdev.c
DMX_REMOVE_PID
drivers/media/dvb/dvb-core/dmxdev.c
FE_SET_PROPERTY
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_GET_PROPERTY
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_GET_INFO
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_DISEQC_RESET_OVERLOAD
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_DISEQC_SEND_MASTER_CMD
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_DISEQC_RECV_SLAVE_REPLY
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_DISEQC_SEND_BURST
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_SET_TONE
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_SET_VOLTAGE
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_ENABLE_HIGH_LNB_VOLTAGE
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_READ_STATUS
drivers/media/dvb/dvb-core/dvb_frontend.c
drivers/media/dvb/frontends/si21xx.c
drivers/media/dvb/frontends/stv0288.c
drivers/media/dvb/frontends/stv0299.c
FE_READ_BER
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_READ_SIGNAL_STRENGTH
drivers/media/dvb/dvb-core/dvb_frontend.c
drivers/media/dvb/frontends/stv0299.c
FE_READ_SNR
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_READ_UNCORRECTED_BLOCKS
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_SET_FRONTEND
drivers/media/dvb/dvb-core/dvb_frontend.c
drivers/media/dvb/frontends/si21xx.c
drivers/media/dvb/frontends/stv0288.c
drivers/media/dvb/frontends/stv0299.c
drivers/media/video/cx23885/cx23885-dvb.c
FE_GET_FRONTEND
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_SET_FRONTEND_TUNE_MODE
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_GET_EVENT
drivers/media/dvb/dvb-core/dvb_frontend.c
FE_DISHNETWORK_SEND_LEGACY_CMD
drivers/media/dvb/dvb-core/dvb_frontend.c
NET_ADD_IF
drivers/media/dvb/dvb-core/dvb_net.c
NET_REMOVE_IF
drivers/media/dvb/dvb-core/dvb_net.c
NET_GET_IF
drivers/media/dvb/dvb-core/dvb_net.c
__NET_ADD_IF_OLD
drivers/media/dvb/dvb-core/dvb_net.c
drivers/media/dvb/ttpci/av7110.c
OSD_GET_CAPABILITY
drivers/media/dvb/ttpci/av7110.c
VIDEO_STOP
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_PLAY
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_FREEZE
drivers/media/dvb/ttpci/av7110.c
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_CONTINUE
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_SELECT_SOURCE
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_SET_BLANK
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_GET_STATUS
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_GET_EVENT
drivers/media/dvb/ttpci/av7110_av.c
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_SET_DISPLAY_FORMAT
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_STILLPICTURE
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_FAST_FORWARD
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_SLOWMOTION
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_GET_CAPABILITIES
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_CLEAR_BUFFER
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_SET_ID
VIDEO_SET_STREAMTYPE
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_SET_FORMAT
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_SET_SYSTEM
VIDEO_SET_HIGHLIGHT
VIDEO_SET_SPU
VIDEO_SET_SPU_PALETTE
VIDEO_GET_NAVI
VIDEO_SET_ATTRIBUTES
VIDEO_GET_SIZE
drivers/media/dvb/ttpci/av7110_av.c
VIDEO_GET_FRAME_RATE
VIDEO_GET_PTS
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_GET_FRAME_COUNT
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_COMMAND
drivers/media/dvb/ttpci/av7110_hw.h
drivers/media/video/ivtv/ivtv-ioctl.c
VIDEO_TRY_COMMAND
drivers/media/video/ivtv/ivtv-ioctl.c
