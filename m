Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40961C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 16:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08BD020868
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 16:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCHQpj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 11:45:39 -0500
Received: from gofer.mess.org ([88.97.38.141]:39879 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfCHQpi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 11:45:38 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 62522602F6; Fri,  8 Mar 2019 16:45:37 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] Add man page describing rc_keymap toml file
Date:   Fri,  8 Mar 2019 16:45:37 +0000
Message-Id: <20190308164537.23434-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 configure.ac                    |   1 +
 utils/ir-ctl/ir-ctl.1.in        |   2 +-
 utils/keytable/.gitignore       |   1 +
 utils/keytable/Makefile.am      |   4 +-
 utils/keytable/ir-keytable.1.in |   1 +
 utils/keytable/rc_keymap.5.in   | 251 ++++++++++++++++++++++++++++++++
 v4l-utils.spec.in               |   1 +
 7 files changed, 258 insertions(+), 3 deletions(-)
 create mode 100644 utils/keytable/rc_keymap.5.in

diff --git a/configure.ac b/configure.ac
index 78cda9ed..4970eece 100644
--- a/configure.ac
+++ b/configure.ac
@@ -70,6 +70,7 @@ AC_CONFIG_FILES([Makefile
 	utils/v4l2-compliance/v4l2-compliance.1
 	utils/v4l2-ctl/v4l2-ctl.1
 	utils/keytable/ir-keytable.1
+	utils/keytable/rc_keymap.5
 	utils/ir-ctl/ir-ctl.1
 	utils/dvb/dvb-fe-tool.1
 	utils/dvb/dvbv5-scan.1
diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 03fcf438..c69ce8b1 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -104,7 +104,7 @@ print the v4l2\-utils version
 .PP
 .SS Format of pulse and space file
 When sending IR, the format of the file should be as follows. A comment
-start with #. The carrier frequency can be specified as:
+starts with #. The carrier frequency can be specified as:
 .PP
 	carrier 38000
 .PP
diff --git a/utils/keytable/.gitignore b/utils/keytable/.gitignore
index 6e1341d9..460e4a13 100644
--- a/utils/keytable/.gitignore
+++ b/utils/keytable/.gitignore
@@ -1,2 +1,3 @@
 ir-keytable
 ir-keytable.1
+rc_keymap.5
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 159520b6..148b9446 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -1,5 +1,5 @@
 bin_PROGRAMS = ir-keytable
-man_MANS = ir-keytable.1
+man_MANS = ir-keytable.1 rc_keymap.5
 sysconf_DATA = rc_maps.cfg
 keytablesystem_DATA = $(srcdir)/rc_keymaps/*
 udevrules_DATA = 70-infrared.rules
@@ -18,7 +18,7 @@ ir_keytable_LDFLAGS += $(LIBELF_LIBS)
 SUBDIRS = bpf_protocols
 endif
 
-EXTRA_DIST = 70-infrared.rules rc_keymaps rc_keymaps_userspace gen_keytables.pl ir-keytable.1 rc_maps.cfg
+EXTRA_DIST = 70-infrared.rules rc_keymaps rc_keymaps_userspace gen_keytables.pl ir-keytable.1 rc_maps.cfg rc_keymap.5
 
 # custom target
 install-data-local:
diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index 47fa1dfe..c0844945 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -135,4 +135,5 @@ License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 This is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
 .SH SEE ALSO
+rc_keymap(5).
 To transmit IR or receive raw IR, see ir\-ctl(1).
diff --git a/utils/keytable/rc_keymap.5.in b/utils/keytable/rc_keymap.5.in
new file mode 100644
index 00000000..4adabbfa
--- /dev/null
+++ b/utils/keytable/rc_keymap.5.in
@@ -0,0 +1,251 @@
+.TH "RC_KEYMAP" "5" "Thu Mar 7 2019" "v4l-utils @PACKAGE_VERSION@" "File Formats"
+.SH NAME
+rc_keymap \- toml file describing remote control keymap
+.SH DESCRIPTION
+An rc_keymap describes a remote control. It list the protocols used, and the mapping from decoded IR to linux input events. This file is used by ir\-keytable(1).
+.TP
+The file format is toml. Since a remote control can use multiple protocols, the top level is an array of protocols. The vast majority of remotes only use one protocol.
+.PP
+.SH PROTOCOLS ENTRY
+For each protocol the remote uses, there should be one entry in the top level \fBprotocols\fR array.
+.SS Name Field
+Each protocols entry has a \fBname\fR field. The name is not used by ir\-keytable, but can be used to give the remote control a more descriptive name than the file name, e.g. the model number.
+.SS Protocol Field
+The \fBprotocol\fR field specifies the protocol. This can either be one of the linux kernel decoders, in which case it is \fBnec\fR, \fBrc\-5\fR, \fBrc\-6\fR, \fBjvc\fR, \fBsony\fR, \fBsanyo\fR, \fBrc\-5\-sz\fR, \fBsharp\fR, \fBmce\-kbd\fR, \fBxmp\fR, \fBimon\fR, \fBrc\-mm\fR, \fBother\fR or \fBunknown\fR. If it does not match any of these entries, then it is assumed to be a BPF based decoder. The \fBunknown\fR and \fBother\fR are protocols decoded by specific RC devices where the protocol is either unknown or proprietary, respectively.
+.PP
+There are some pre-defined BPF protocol decoders, which are listed below. See
+.UR https://lwn.net/Articles/759188/
+.UE 
+for how to write your own.
+.SS Variant Field
+The \fBvariant\fR field specifies which variant a particular protocol uses. The \fBsony\fR, \fBrc-5\fR, \fBrc-6\fR protocols have different bit length variants, for example. This field is not currently used. However, this is needed should the keymap be used for sending IR, rather than decoding it.
+.TP
+The following variants are currently defined:
+.PP
+Protocol \fBrc-5\fR has variants \fBrc-5\fR, \fBrc-5x-20\fR, \fBrc-5-sz\fR.
+.TP
+Protocol \fBnec\fR has variants \fBnec\fR, \fBnec-x\fR, \fBnec-32\fR.
+.TP
+Protocol \fBsony\fR has variants \fBsony-12\fR, \fBsony-15\fR, \fBsony-20\fR.
+.TP
+Protocol \fBrc\-6\fR has variants \fBrc-6-0\fR, \fBrc-6-6a-20\fR, \fBrc-6-6a-24\fR, \fBrc-6-6a-32\fR, \fBrc-6-mce\fR.
+.TP
+Protocol \fBrc\-mm\fR has variants \fBrc-mm-12\fR, \fBrc-mm-24\fR, and \fBrc-mm-32\fR.
+.SS Scancodes field
+The \fBscancodes\fR array list the scancodes and the mapping to linux input key events. Multiple scancodes can map to the same key event.
+.PP
+If the scancode start with 0x, it is interpreted as a hexadecimal number. If it starts with a 0, it is interpreted as an octal number.
+.PP
+The key events are listed in the \fBinput-event-codes.h\fR header file. Examples are \fBKEY_ENTER\fR, \fBKEY_ESC\fR or \fBBTN_LEFT\fR for the left mouse button.
+.SS Remaining fields (BPF parameters)
+If the protocol is a BPF based decoder, it may have any number of numeric parameters. These parameters are used to support protocols with non-standard signaling lengths for standard IR protocols. Any other field specified here which is required by the selected BPF decoder will be used. All other fields are ignored.
+
+Kernel based non-BPF protocol decoders do not have any parameters.
+.PP
+.SH BPF PROTOCOLS 
+.PP
+Some of the BPF protocol decoders are generic and will need parameters to work. Other are for specific remotes and should work without any parameters. The timing parameters are all in microseconds (µs).
+.SS imon_rsc
+This decoder is specifically for the iMON RSC remote, which was packaged with the iMON Station (amonst others). The decoder is for the directional stick in the middle; it will decode them into mouse movements. The buttons are all encoded using nec-x so the keymap needs two protocols to work correctly.
+
+This is unrelated to the \fBimon\fR protocol.
+.TP
+\fBmargin\fR
+Define how much tolerance there is for message length. Default 200.
+.PP
+.SS grundig
+This decoder is specifically for old grundig remotes.
+.TP
+\fBheader_pulse\fR
+Length of first pulse, default 900
+.TP
+\fBheader_space\fR
+Length of following space, default 2900
+.TP
+\fBleader_pulse\fR
+Length of second pulse, default 1300
+.PP
+.SS xbox
+This decoder is specifically for the XBox Remote DVD, which is for the first generation XBox.
+.TP
+\fBmargin\fR
+Define how much tolerance there is for message length. Default 200.
+.SS manchester
+Most manchester encoded remote controls are either rc\-5, rc\-6, or rc\-mm. Some remote use a different variant and that is what the decoder is for. The various parameters must be specified.
+.TP
+\fBmargin\fR
+Define how much tolerance there is for message length. Default 200.
+.TP
+\fBheader_pulse\fR
+Define how long a leading pulse is. This is not always present. Default 0.
+.TP
+\fBheader_space\fR
+Define how long the space is after the leading pulse. Must be set if \fBheader\_pulse\fR is set.
+.TP
+\fBzero\_pulse\fR, \fBzero\_space\fR, \fBone\_pulse\fR, \fBone\_space\fR
+Signally lengths for bits. See
+.UR https://clearwater.com.au/code/rc5
+.UE
+for these are defined.
+.TP
+\fBbits\fR
+Number of bits. Default 14.
+.TP
+\fBscancode\_mask\fR
+Bits to mask out of resulting scancode.
+.TP
+\fBtoggle\_bit\fR
+Bit that specifies the toggle. If this value is greater than the number of bits, no toggle is defined.
+.SS pulse\_distance
+This is a generic decoder for protocols that define bits by distance between pulses, and the pulses are always of the same length. The most well known protocol like this is \fBnec\fR. This decoder is cases where \fBnec\fR is not used. The parameters must be set.
+.TP
+\fBmargin\fR
+Define how much tolerance there is for message length. Default 200.
+.TP
+\fBheader_pulse\fR
+Length of the first leading pulse. Default 2125.
+.TP
+\fBheader_space\fR
+Length of the space after the leading pulse. Default 1875.
+.TP
+\fBrepeat_pulse\fR
+Length of the leading pulse for key repeat. Default 0.
+.TP
+\fBrepeat_space\fR
+Length of the space after the leading pulse for key repeat. Default 0.
+Default 0.
+.TP
+\fBbit_pulse\fR
+Length of the pulse for each bit. Default 625.
+.TP
+\fBbit_0_space\fR
+Length of the space for a zero bit. Default 375.
+.TP
+\fBbit_1_space\fR
+Length of the space for a one bit. Default 1625.
+.TP
+\fBtrailer_pulse\fR
+Length of the pulse after the last bit. Needed to bookend the last bit. Default 625.
+.TP
+\fBbits\fR
+Number of bits. Default 4.
+.TP
+\fBreverse\fR
+Should the bits be read in least significant bit first. Set to non-zero to enable. Default 0.
+.TP
+\fBheader_optional\fR
+Some remotes do not send the header pulse and space for key repeats, so set this to non-zero to make the header optional. Default 0.
+
+An alternative implementation might only allow missing headers for repeat messages, but this would fail to decode key presses if only the first message did not decode correctly to due interference.
+
+
+.SS pulse\_length
+This is a generic decoder for protocols that define bits by length of pulses, and the spaces are always the same. The \fBsony\fR protocol is the most well-known protocol, but this decoder is for protocols which are not \fBsony\fR.
+.TP
+\fBmargin\fR
+Define how much tolerance there is for message length. Default 200.
+.TP
+\fBheader_pulse\fR
+Length of the first leading pulse. Default 2125.
+.TP
+\fBheader_space\fR
+Length of the space after the leading pulse. Default 1875.
+.TP
+\fBrepeat_pulse\fR
+Length of the leading pulse for key repeat. Default 0.
+.TP
+\fBrepeat_space\fR
+Length of the space after the leading pulse for key repeat. Default 0.
+Default 0.
+.TP
+\fBbit_space\fR
+Length of the space for each bit. Default 625.
+.TP
+\fBbit_0_pulse\fR
+Length of the pulse for a zero bit. Default 375.
+.TP
+\fBbit_1_pulse\fR
+Length of the pulse for a one bit. Default 1625.
+.TP
+\fBtrailer_pulse\fR
+Length of the pulse after the last bit. Optional. Default 0.
+.TP
+\fBbits\fR
+Number of bits. Default 4.
+.TP
+\fBreverse\fR
+Should the bits be read in least significant bit first. Set to non-zero to enable. Default 0.
+.TP
+\fBheader_optional\fR
+Some remotes do not send the header pulse and space for key repeats, so set this to non-zero to make the header optional. Default 0.
+
+An alternative implementation might only allow missing headers for repeat messages, but this would fail to decode key presses if only the first message did not decode correctly to due interference.
+
+.SH EXAMPLE
+.EX
+[[protocols]]
+name = "iMON Station RSC"
+protocol = "nec"
+variant = "necx"
+[protocols.scancodes]
+0x801010 = "KEY_EXIT"
+0x80102f = "KEY_POWER"
+0x80104a = "KEY_SCREENSAVER"
+0x801049 = "KEY_TIME"
+0x801054 = "KEY_NUMERIC_1"
+0x801055 = "KEY_NUMERIC_2"
+0x801056 = "KEY_NUMERIC_3"
+0x801057 = "KEY_NUMERIC_4"
+0x801058 = "KEY_NUMERIC_5"
+0x801059 = "KEY_NUMERIC_6"
+0x80105a = "KEY_NUMERIC_7"
+0x80105b = "KEY_NUMERIC_8"
+0x80105c = "KEY_NUMERIC_9"
+0x801081 = "KEY_SCREEN"
+0x80105d = "KEY_NUMERIC_0"
+0x801082 = "KEY_MAX"
+0x801048 = "KEY_ESC"
+0x80104b = "KEY_MEDIA"
+0x801083 = "KEY_MENU"
+0x801045 = "KEY_APPSELECT"
+0x801084 = "KEY_STOP"
+0x801046 = "KEY_CYCLEWINDOWS"
+0x801085 = "KEY_BACKSPACE"
+0x801086 = "KEY_KEYBOARD"
+0x801087 = "KEY_SPACE"
+0x80101e = "KEY_RESERVED"
+0x801098 = "BTN_0"
+0x80101f = "KEY_TAB"
+0x80101b = "BTN_LEFT"
+0x80101d = "BTN_RIGHT"
+0x801016 = "BTN_MIDDLE"
+0x801088 = "KEY_MUTE"
+0x80105e = "KEY_VOLUMEDOWN"
+0x80105f = "KEY_VOLUMEUP"
+0x80104c = "KEY_PLAY"
+0x80104d = "KEY_PAUSE"
+0x80104f = "KEY_EJECTCD"
+0x801050 = "KEY_PREVIOUS"
+0x801051 = "KEY_NEXT"
+0x80104e = "KEY_STOP"
+0x801052 = "KEY_REWIND"
+0x801053 = "KEY_FASTFORWARD"
+0x801089 = "KEY_ZOOM"
+[[protocols]]
+protocol = "imon_rsc"
+.EE
+.SH BUGS
+Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
+.SH COPYRIGHT
+Copyright (C) 2019 by Sean Young <sean@mess.org>
+.PP
+License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free to change and redistribute it.
+There is NO WARRANTY, to the extent permitted by law.
+.SH SEE ALSO
+ir\-keytable(1).
+.PP
+https://lwn.net/Articles/759188/
+.PP
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/input-event-codes.h#n64
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
index 67bdca57..ab0726bb 100644
--- a/v4l-utils.spec.in
+++ b/v4l-utils.spec.in
@@ -160,6 +160,7 @@ gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
 %{_bindir}/v4l2-ctl
 %{_bindir}/v4l2-sysfs-path
 %{_mandir}/man1/ir-keytable.1*
+%{_mandir}/man5/rc_keymap.5*
 %{_mandir}/man1/ir-ctl.1*
 
 %files devel-tools
-- 
2.20.1

