Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57010 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbaKUTiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 14:38:19 -0500
Message-ID: <546F9496.9020207@xs4all.nl>
Date: Fri, 21 Nov 2014 20:37:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: v4l-utils stable release 1.6.1
References: <546E093D.4030203@googlemail.com>
In-Reply-To: <546E093D.4030203@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

On 11/20/2014 04:31 PM, Gregor Jasny wrote:
> Hello,
> 
> do you consider something from these commits as important enough for a 
> bugfix release?
> 
> Thanks,
> Gregor
> 
>> Akihiro Tsukada (9):
>>       libdvbv5, dvbv5-scan: generalize channel duplication check
>>       libdvbv5: add as many channels as possible in scanning DVB-T2
>>       libdvbv5: wrong frequency in the output of satellite delsys scans
>>       libdvbv5: add support for ISDB-S tuning
>>       libdvbv5: add support for ISDB-S scanning
>>       libdvbv5: add COUNTRY property
>>       v4l-utils/libdvbv5: restore deleted functions to keep API/ABI compatible
>>       v4l-utils/libdvbv5: fix memory leak in dvb_guess_user_country()
>>       v4l-utils/libdvbv5: add gconv module for the text conversions of ISDB-S/T.
>>
>> Gregor Jasny (7):
>>       Start v4l-utils 1.7.0 development cycle
>>       man: remove duplicate backslash from NAME section
>>       man: Use Unicode character for ellipsis and fall back to ...
>>       man: add generated files to .gitignore
>>       libdvbv5: Remove stray semicolon
>>       v4l2-compliance: Explicitely link against rt library
>>       v4l2-ctl: Explicitely link against rt library
>>
>> Hans Verkuil (10):
>>       qv4l2/v4l2-ctl: fix buffer overrun in vivid-tpg.

This one should go in (critical bug fix).

>>       v4l2-ctl: fix sliced vbi mode parsing

And this one.

>>       v4l2-compliance: when streaming used at least 2 buffers.
>>       v4l2-compliance: add initial checks for VIDIOC_QUERY_EXT_CTRL
>>       v4l2-ctl: add support for U32 control type.
>>       v4l2-ctl: fix array handling

And these two for v4l2-ctl.

Sorry for being late with replying.

Regards,

	Hans

>>       v4l2-compliance: allow the V4L2_IN_ST_NO_SYNC status flag.
>>       qv4l2: add single step support
>>       qv4l2: don't select alsa device for video output.
>>       v4l2-compliance: select(): split "ret <= 0" test in two
>>
>> Hans de Goede (2):
>>       rc_keymaps: allwinner: S/KEY_HOME/KEY_HOMEPAGE/
>>       v4lconvert: Fix decoding of jpeg data with no vertical sub-sampling
>>
>> Mauro Carvalho Chehab (41):
>>       libdvbv5: properly represent Satellite frequencies
>>       README: better document the package
>>       libdvbv5: Fix some Doxygen warnings at dvb-fe.h
>>       Doxygen: Document libdvbv5 countries.h
>>       configure.ac: Fix gconv compilation with 64 bits
>>       parse_tcpdump_log.pl: only adjust direction for control EP
>>       contrib: add a parser for af9035
>>       parse_af9035.pl: properly handle URB errors
>>       parse_af9035.pl: Add two other commands from ITE driver
>>       parse_af9035.pl: add arguments to show timestamp and debug
>>       parse_af9035.pl: group write/read URBs
>>       parse_af9035.pl: create a routine to print send/race
>>       parse_af9035.pl: print read/write as C lines
>>       parse_af9035.pl: add support for firmware commands
>>       parse_af9035.pl: fix firmware write size
>>       ir-keytable: fix a regression introduced by fe2aa5f767eba
>>       gen_keytables.pl: Fix a regression at RC map file generation
>>       rc: Update the protocol name at RC6 tables
>>       rc_maps.cfg: reorder entries alphabetically
>>       rc: sync with Kernel
>>       rc: copy userspace-only maps to a separate dir
>>       README: Add the steps needed to syncronize with the Kernel tree
>>       vivid-tpg.h.patch: update to match current upstream tree
>>       Synchronize with the Kernel
>>       parse_af9035.pl: proper handle when stack is not filled
>>       parse_af9035.pl: add support for CMD_IR_GET
>>       parse_af9035.pl: add options to hide part of the messages
>>       parse_af9035.pl: Add firmware boot message to the parser
>>       parse_af9035.pl: improve IR handling
>>       parse_af9035.pl: add support for generic I2C read/write
>>       parse_af9035.pl: better handle the read data
>>       parse_af9035.pl: allow to hide parsing errors
>>       parse_af9035.pl: add support for standard I2C commands
>>       parse_af9035.pl: some cleanups
>>       parse_af9035.pl: Fix decoding order at I2C read/write
>>       parse_af9035.pl: Fix size on rd/wr regs prints
>>       parse_af9035.pl: Fix some hide conditions
>>       parse_af9035.pl: Improve argument handling
>>       libdvbv5: add experimental DTMB support
>>       parse_tcpdump_log.pl: simplify non-control data
>>       parse_tcpdump_log.pl: remove some leftovers
>>
>> Niels Ole Salscheider (1):
>>       qv4l2: Fix out-of-source build
>>
>> Patrick Boettcher (4):
>>       parse_tcpdump_log.pl: skip filtered frames and remove them from pending
>>       parse_tcpdump_log.pl: show transfer-direction for non-ctrl-transfers
>>       parse_tcpdump_log.pl: add external frame_processor-option
>>       parse_tcpdump_log.pl: remove --all option which was not documented and not working as expected
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

