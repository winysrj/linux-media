Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab2HVSJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 14:09:21 -0400
Message-ID: <50352044.7040104@redhat.com>
Date: Wed, 22 Aug 2012 15:09:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mike Isely at pobox <isely@pobox.com>
CC: Mike Isely <isely@isely.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: Core + Radio profile
References: <201208221140.25656.hverkuil@xs4all.nl> <201208221211.47842.hverkuil@xs4all.nl> <5034E1C2.30205@redhat.com> <alpine.DEB.2.00.1208221013110.8031@cnc.isely.net>
In-Reply-To: <alpine.DEB.2.00.1208221013110.8031@cnc.isely.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-08-2012 12:19, Mike Isely escreveu:
> On Wed, 22 Aug 2012, Mauro Carvalho Chehab wrote:
> 
>> Em 22-08-2012 07:11, Hans Verkuil escreveu:
>>> I've added some more core profile requirements.
>>
>>>>
>>>> Streaming I/O is not supported by radio nodes.
>>
>> 	Hmm... pvrusb2/ivtv? Ok, it makes sense to move it to use the alsa
>> mpeg API there. If we're enforcing it, we should deprecate the current way
>> there, and make it use ALSA.
> 
> I am unaware of any ALSA MPEG API.  It's entirely likely that this is 
> because I haven't been paying attention.  Nevertheless, can you please 
> point me at any documentation on this so I can get up to speed?


I don't know much about that. A grep at sound might help:

$ git grep -i mpeg sound/
sound/core/oss/pcm_oss.c: case AFMT_MPEG:         return SNDRV_PCM_FORMAT_MPEG;
sound/core/oss/pcm_oss.c: case SNDRV_PCM_FORMAT_MPEG:             return AFMT_MPEG;
sound/core/pcm.c: FORMAT(MPEG),
sound/core/pcm.c: case AFMT_MPEG:
sound/core/pcm.c:         return "MPEG";
sound/core/pcm_misc.c:    [SNDRV_PCM_FORMAT_MPEG] = {
sound/drivers/vx/vx_cmd.h:#define MASK_VALID_PIPE_MPEG_PARAM      0x000040
sound/drivers/vx/vx_cmd.h:#define MASK_SET_PIPE_MPEG_PARAM        0x000002
sound/drivers/vx/vx_cmd.h:#define P_PREPARE_FOR_MPEG3_MASK        
sound/drivers/vx/vx_core.c:       if (chip->audio_info & VX_AUDIO_INFO_MPEG1)
sound/drivers/vx/vx_core.c:               snd_iprintf(buffer, " mpeg1");
sound/drivers/vx/vx_core.c:       if (chip->audio_info & VX_AUDIO_INFO_MPEG2)
sound/drivers/vx/vx_core.c:               snd_iprintf(buffer, " mpeg2");
sound/pci/asihpi/asihpi.c:        -1,                     /* HPI_FORMAT_MPEG_L1              3 */
sound/pci/asihpi/asihpi.c:        SNDRV_PCM_FORMAT_MPEG,  /* HPI_FORMAT_MPEG_L2              4 */
sound/pci/asihpi/asihpi.c:        SNDRV_PCM_FORMAT_MPEG,  /* HPI_FORMAT_MPEG_L3              5 */
sound/pci/asihpi/hpi.h:/** MPEG-1 Layer-1. */
sound/pci/asihpi/hpi.h:   HPI_FORMAT_MPEG_L1 = 3,
sound/pci/asihpi/hpi.h:/** MPEG-1 Layer-2.
sound/pci/asihpi/hpi.h:Windows equivalent is WAVE_FORMAT_MPEG.
sound/pci/asihpi/hpi.h:   HPI_FORMAT_MPEG_L2 = 4,
sound/pci/asihpi/hpi.h:/** MPEG-1 Layer-3.
sound/pci/asihpi/hpi.h:Windows equivalent is WAVE_FORMAT_MPEG.
sound/pci/asihpi/hpi.h:   HPI_FORMAT_MPEG_L3 = 5,
sound/pci/asihpi/hpi.h:#define HPI_CAPABILITY_MPEG_LAYER3      (1)
sound/pci/asihpi/hpi.h:/** MPEG Ancillary Data modes
sound/pci/asihpi/hpi.h:enum HPI_MPEG_ANC_MODES {
sound/pci/asihpi/hpi.h:   /** the MPEG frames have energy information stored in them (5 bytes per stereo frame, 3 per mono) */
sound/pci/asihpi/hpi.h:   HPI_MPEG_ANC_HASENERGY = 0,
sound/pci/asihpi/hpi.h:   HPI_MPEG_ANC_RAW = 1
sound/pci/asihpi/hpi.h:enum HPI_ISTREAM_MPEG_ANC_ALIGNS {
sound/pci/asihpi/hpi.h:   HPI_MPEG_ANC_ALIGN_LEFT = 0,
sound/pci/asihpi/hpi.h:   HPI_MPEG_ANC_ALIGN_RIGHT = 1
sound/pci/asihpi/hpi.h:/** MPEG modes
sound/pci/asihpi/hpi.h:MPEG modes - can be used optionally for HPI_FormatCreate()
sound/pci/asihpi/hpi.h:Using any mode setting other than HPI_MPEG_MODE_DEFAULT
sound/pci/asihpi/hpi.h:enum HPI_MPEG_MODES {
sound/pci/asihpi/hpi.h:/** Causes the MPEG-1 Layer II bitstream to be recorded
sound/pci/asihpi/hpi.h:   HPI_MPEG_MODE_DEFAULT = 0,
sound/pci/asihpi/hpi.h:   HPI_MPEG_MODE_STEREO = 1,
sound/pci/asihpi/hpi.h:   HPI_MPEG_MODE_JOINTSTEREO = 2,
sound/pci/asihpi/hpi.h:   HPI_MPEG_MODE_DUALCHANNEL = 3
sound/pci/asihpi/hpi.h:/** maximum number of ancillary bytes per MPEG frame */
sound/pci/asihpi/hpi.h:   u32 bit_rate;             /**< for MPEG */
sound/pci/asihpi/hpi.h:   u16 format;       /**< HPI_FORMAT_PCM16, _MPEG etc. see #HPI_FORMATS. */
sound/pci/asihpi/hpi_internal.h:  u32 bit_rate; /**< for MPEG */
sound/pci/asihpi/hpi_internal.h:  u16 format; /**< HPI_FORMAT_PCM16, _MPEG etc. see \ref HPI_FORMATS. */
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L1:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L2:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L3:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L1:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L2:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L3:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L2:
sound/pci/asihpi/hpifunc.c:                       && (attributes != HPI_MPEG_MODE_DEFAULT)) {
sound/pci/asihpi/hpifunc.c:                       attributes = HPI_MPEG_MODE_DEFAULT;
sound/pci/asihpi/hpifunc.c:               } else if (attributes > HPI_MPEG_MODE_DUALCHANNEL) {
sound/pci/asihpi/hpifunc.c:                       attributes = HPI_MPEG_MODE_DEFAULT;
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L1:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L2:
sound/pci/asihpi/hpifunc.c:       case HPI_FORMAT_MPEG_L3:
sound/pci/bt87x.c: * (DVB cards use the audio function to transfer MPEG data) */
sound/pci/ens1370.c:#define   ES_MSFMTSEL         (1<<15)         /* MPEG serial data format; 0 = SONY, 1 = I2S */
sound/pci/ens1370.c:#define   ES_1370_M_SBB               (1<<14)         /* clock source for DAC - 0 = clock generator; 1 = MPEG clocks */
sound/pci/ens1370.c:#define   ES_1370_M_CB                (1<<9)          /* capture clock source; 0 = ADC; 1 = MPEG */
sound/pci/hda/hda_eld.c:  AUDIO_CODING_TYPE_MPEG1                 =  3,
sound/pci/hda/hda_eld.c:  AUDIO_CODING_TYPE_MPEG2                 =  5,
sound/pci/hda/hda_eld.c:  AUDIO_CODING_TYPE_MPEG_SURROUND         = 17,
sound/pci/hda/hda_eld.c:  AUDIO_CODING_XTYPE_MPEG_SURROUND        = 3,
sound/pci/hda/hda_eld.c:  /*  3 */ "MPEG1",
sound/pci/hda/hda_eld.c:  /*  5 */ "MPEG2",
sound/pci/hda/hda_eld.c:  /* 17 */ "MPEG Surround",
sound/pci/hda/hda_eld.c:  case AUDIO_CODING_TYPE_MPEG1:
sound/pci/hda/hda_eld.c:  case AUDIO_CODING_TYPE_MPEG2:
sound/pci/mixart/mixart_core.h:   CT_MPEG_L1,
sound/pci/mixart/mixart_core.h:   CT_MPEG_L2,
sound/pci/mixart/mixart_core.h:   CT_MPEG_L3,
sound/pci/mixart/mixart_core.h:   CT_MPEG_L3_LSF,
sound/pci/mixart/mixart_core.h:                   u32 mpeg_layer;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_mode;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_mode_extension;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_pre_emphasis;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_has_padding_bit;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_has_crc;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_has_extension;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_is_original;
sound/pci/mixart/mixart_core.h:                   u32 mpeg_has_copyright;
sound/pci/mixart/mixart_core.h:           } mpeg_format_info;
sound/usb/format.c:       case UAC_FORMAT_TYPE_II_MPEG:
sound/usb/format.c:               fp->formats = SNDRV_PCM_FMTBIT_MPEG;
sound/usb/format.c:               snd_printd(KERN_INFO "%d:%u:%d : unknown format tag %#x is detected.  processed as MPEG.\n",
sound/usb/format.c:               fp->formats = SNDRV_PCM_FMTBIT_MPEG;


> 
> Currently the pvrusb2 driver does not attempt to perform any processing 
> or filtering of the data stream, so radio data is just the same mpeg 
> stream as video (but without any real embedded video data).  If I have 
> to get into the business of processing the MPEG data in order to adhere 
> to this proposal, then that will be a very big deal for this driver.

I _suspect_ that it is just a matter of adding something like em28xx-audio
at pvrusb2, saying that the format is MPEG, instead of raw PCM. In-kernel
processing is likely not needed/wanted.

We may try to double check with Takashi during the KS media workshop.

Regards,
Mauro
