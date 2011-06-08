Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1FHViW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 17:38:22 -0400
Message-ID: <4DEFEBCA.1030909@redhat.com>
Date: Wed, 08 Jun 2011 18:38:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
References: <20110608172311.0d350ab7@pedra> <201106082259.33770.hverkuil@xs4all.nl>
In-Reply-To: <201106082259.33770.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-06-2011 17:59, Hans Verkuil escreveu:
> On Wednesday, June 08, 2011 22:23:11 Mauro Carvalho Chehab wrote:
>> There's a huge gap between the DVB specs and the current implementation.
>> This were caused by years of changes that happened at the code but
>> no updates to the specs were done.
>>
>> This patch series tries to reduce this gap.
>>
>> Basically, the headers at include/linux/dvb were included at the API.
>> The Makefile scripting auto-generate references for structs, typedefs
>> and ioctls. With this, it is now easy to identify when something is
>> missing.
>>
>> After adding such logic, I've manually synchronized the specs with the
>> header file and updated the data structures.
>>
>> The work is not complete yet: there are still several ioctl's not
>> documented at the specs:
>>
>> Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
> ...
>> Error: no ID for constraint linkend: VIDEO_GET_SIZE.
>> Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
>> Error: no ID for constraint linkend: VIDEO_GET_PTS.
>> Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
>> Error: no ID for constraint linkend: VIDEO_COMMAND.
>> Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.
> 
> A lot of these video/audio commands should be converted to V4L ioctls.

Agreed.

> VIDEO_COMMAND and VIDEO_TRY_COMMAND should become VIDIOC_(TRY_)DECODER_CMD,
> the others can either be integrated into VIDIOC_DECODER_CMD or become
> (read-only) controls or something similar. Or just dropped if no apps use them.
> 
> The only drivers that use these at the moment are ivtv and av7110. At least for
> ivtv I'd love to switch to V4L ioctls (documented and all) and leave the old
> VIDEO/AUDIO ioctls as specific to av7110 (just like osd.h).

That seems to be the right approach to me.

> Realistically this would be a job for me, but I am still way too busy to
> tackle something like this.
> 
>> I also opted to not add the osd.h header into the DocBook, as it seemed
>> odd on my eyes, and it is used only by one legacy hardware.
>>
>> While here, I noticed that one audio ioctl is not used anyware
>> (AUDIO_GET_PTS). There is just the ioctl definition and that's it. 
>> I just removed this definition, as removing it won't cause any 
>> regression, as no in-kernel driver or dvb-core uses it.
> 
> It was originally planned to be used in ivtv, but this never happened.
> 
>> Btw, there are several ioctl's and correponding data structures that
>> are used on just one or two old drivers. I think we should consider
>> to deprecate those old stuff.
> 
> Which? If you have a list of those, then that would make for an interesting
> RFC.

Well, with a simple git grep, we can check this:

$ for i in $(perl -ne 'print "$1\n" if /\#define\s+([^\s]+)\s+_IO/' include/linux/dvb/*); do echo $i; git grep -l $i drivers/media ; done
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

Basically:

- all AUDIO*, OSD* and VIDEO* are used only by av7110 and ivtv.

- The CA* ioctls are used by core (although several are only implemented
  inside a few drivers);

- All the DMX*, FE*, NET* ioctl's are implemented inside the core.

I'll write a RFC.

> 
> Regards,
> 
> 	Hans
> 
>>
>> Mauro Carvalho Chehab (13):
>>   [media] DocBook: Add the other DVB API header files
>>   [media] DocBook/audio.xml: match section ID's with the reference links
>>   [media] DocBook/audio.xml: synchronize attribute changes
>>   [media] DocBook: Document AUDIO_CONTINUE ioctl
>>   [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
>>   [media] Docbook/ca.xml: match section ID's with the reference links
>>   [media] DocBook/ca.xml: Describe structure ca_pid
>>   [media] DocBook/demux.xml: Fix section references with dmx.h.xml
>>   [media] DocBook/demux.xml: Add the remaining data structures to the API spec
>>   [media] DocBook/net.xml: Synchronize Network data structure
>>   [media] DocBook/Makefile: Remove osd.h header
>>   [media] DocBook/video.xml: Fix section references with video.h.xml
>>   [media] DocBook/video.xml: Document the remaining data structures
>>
>>  Documentation/DocBook/media/Makefile       |   81 ++++++++++-
>>  Documentation/DocBook/media/dvb/audio.xml  |  176 +++++++++++++++--------
>>  Documentation/DocBook/media/dvb/ca.xml     |  106 ++++++++------
>>  Documentation/DocBook/media/dvb/demux.xml  |  206 +++++++++++++++-----------
>>  Documentation/DocBook/media/dvb/dvbapi.xml |   20 +++
>>  Documentation/DocBook/media/dvb/intro.xml  |   19 +++-
>>  Documentation/DocBook/media/dvb/net.xml    |   17 ++
>>  Documentation/DocBook/media/dvb/video.xml  |  220 +++++++++++++++++-----------
>>  include/linux/dvb/audio.h                  |   14 +--
>>  9 files changed, 564 insertions(+), 295 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

