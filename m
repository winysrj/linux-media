Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40008 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbeEFKe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 06:34:57 -0400
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-media@vger.kernel.org, Alec Leamas <leamas.alec@gmail.com>
Subject: Re: [PATCH] lirc.4: remove ioctls and feature bits which were never
 implemented
To: Sean Young <sean@mess.org>
References: <20180423102637.xtcjidetxo6iaslx@gofer.mess.org>
From: "Michael Kerrisk (man-opages)" <mtk.manpages@gmail.com>
Message-ID: <6b531be3-56ea-b534-3493-d64c98b3f6c5@gmail.com>
Date: Sun, 6 May 2018 12:34:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180423102637.xtcjidetxo6iaslx@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[CCing original author of this page]


On 04/23/2018 12:26 PM, Sean Young wrote:
> The lirc header file included ioctls and feature bits which were never
> implemented by any driver. They were removed in commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d55f09abe24b4dfadab246b6f217da547361cdb6

Alec, does this patch look okay to you?

Cheers,

Michael

> Signed-off-by: Sean Young <sean@mess.org>
> ---
>   man4/lirc.4 | 92 ++-----------------------------------------------------------
>   1 file changed, 2 insertions(+), 90 deletions(-)
> 
> diff --git a/man4/lirc.4 b/man4/lirc.4
> index 1e94a7163..3adff55f1 100644
> --- a/man4/lirc.4
> +++ b/man4/lirc.4
> @@ -78,9 +78,7 @@ The package reflects a timeout; see the
>   .B LIRC_SET_REC_TIMEOUT_REPORTS
>   ioctl.
>   .\"
> -.SS Reading input with the
> -.B LIRC_MODE_LIRCCODE
> -drivers
> +.SS Reading input with the LIRC_MODE_LIRCCODE drivers
>   .PP
>   In the \fBLIRC_MODE_LIRCCODE\fR
>   mode, the data returned by
> @@ -204,17 +202,11 @@ Currently serves no purpose since only
>   .BR LIRC_MODE_PULSE
>   is supported.
>   .TP
> -.BR LIRC_GET_SEND_CARRIER " (\fIvoid\fP)"
> -Get the modulation frequency (Hz).
> -.TP
>   .BR LIRC_SET_SEND_CARRIER " (\fIint\fP)"
>   Set the modulation frequency.
>   The argument is the frequency (Hz).
>   .TP
> -.BR LIRC_GET_SEND_CARRIER " (\fIvoid\fP)"
> -Get the modulation frequency used when decoding (Hz).
> -.TP
> -.BR SET_SEND_DUTY_CYCLE " (\fIint\fP)"
> +.BR LIRC_SET_SEND_DUTY_CYCLE " (\fIint\fP)"
>   Set the carrier duty cycle.
>   .I val
>   is a number in the range [0,100] which
> @@ -284,36 +276,6 @@ By default this should be turned off.
>   .BR LIRC_GET_REC_RESOLUTION " (\fIvoid\fP)"
>   Return the driver resolution (microseconds).
>   .TP
> -.BR LIRC_GET_MIN_FILTER_PULSE " (\fIvoid\fP)", " " \
> -LIRC_GET_MAX_FILTER_PULSE " (\fIvoid\fP)"
> -Some devices are able to filter out spikes in the incoming signal
> -using given filter rules.
> -These ioctls return the hardware capabilities that describe the bounds
> -of the possible filters.
> -Filter settings depend on the IR protocols that are expected.
> -.BR lircd (8)
> -derives the settings from all protocols definitions found in its
> -.BR lircd.conf (5)
> -config file.
> -.TP
> -.BR LIRC_GET_MIN_FILTER_SPACE " (\fIvoid\fP)", " " \
> -LIRC_GET_MAX_FILTER_SPACE " (\fIvoid\fP)"
> -See
> -.BR LIRC_GET_MIN_FILTER_PULSE .
> -.TP
> -.BR LIRC_SET_REC_FILTER " (\fIint\fP)"
> -Pulses/spaces shorter than this (microseconds) are filtered out by
> -hardware.
> -.TP
> -.BR LIRC_SET_REC_FILTER_PULSE " (\fIint\fP)", " " \
> -LIRC_SET_REC_FILTER_SPACE " (\fIint\fP)"
> -Pulses/spaces shorter than this (microseconds) are filtered out by
> -hardware.
> -If filters cannot be set independently for pulse/space, the
> -corresponding ioctls must return an error and
> -.BR LIRC_SET_REC_FILTER
> -should be used instead.
> -.TP
>   .BR LIRC_SET_TRANSMITTER_MASK
>   Enable the set of transmitters specified in
>   .IR val ,
> @@ -343,32 +305,6 @@ carrier reports.
>   In that case, it will be disabled as soon as you disable carrier reports.
>   Trying to disable a wide band receiver while carrier reports are active
>   will do nothing.
> -.TP
> -.BR LIRC_SETUP_START " (\fIvoid\fP), " LIRC_SETUP_END " (\fIvoid\fP)"
> -Setting of several driver parameters can be optimized by bracketing
> -the actual ioctl calls
> -.BR LIRC_SETUP_START
> -and
> -.BR LIRC_SETUP_END .
> -When a driver receives a
> -.BR LIRC_SETUP_START
> -ioctl, it can choose to not commit further setting changes to the
> -hardware until a
> -.BR LIRC_SETUP_END
> -is received.
> -But this is open to the driver implementation and every driver
> -must also handle parameter changes which are not encapsulated by
> -.BR LIRC_SETUP_START
> -and
> -.BR LIRC_SETUP_END .
> -Drivers can also choose to ignore these ioctls.
> -.TP
> -.BR LIRC_NOTIFY_DECODE " (\fIvoid\fP)"
> -This ioctl is called by
> -.BR lircd (8)
> -whenever a successful decoding of an incoming IR signal is possible.
> -This can be used by supporting hardware to give visual user
> -feedback, for example by flashing an LED.
>   .\"
>   .SH FEATURES
>   .PP
> @@ -378,14 +314,6 @@ The
>   ioctl returns a bit mask describing features of the driver.
>   The following bits may be returned in the mask:
>   .TP
> -.BR LIRC_CAN_REC_RAW
> -The driver is capable of receiving using
> -.BR LIRC_MODE_RAW .
> -.TP
> -.BR LIRC_CAN_REC_PULSE
> -The driver is capable of receiving using
> -.BR LIRC_MODE_PULSE .
> -.TP
>   .BR LIRC_CAN_REC_MODE2
>   The driver is capable of receiving using
>   .BR LIRC_MODE_MODE2 .
> @@ -426,10 +354,6 @@ The driver supports
>   The driver supports
>   .BR LIRC_SET_REC_TIMEOUT .
>   .TP
> -.BR LIRC_CAN_SET_REC_FILTER
> -The driver supports
> -.BR LIRC_SET_REC_FILTER .
> -.TP
>   .BR LIRC_CAN_MEASURE_CARRIER
>   The driver supports measuring of the modulation frequency using
>   .BR LIRC_SET_MEASURE_CARRIER_MODE .
> @@ -438,22 +362,10 @@ The driver supports measuring of the modulation frequency using
>   The driver supports learning mode using
>   .BR LIRC_SET_WIDEBAND_RECEIVER .
>   .TP
> -.BR LIRC_CAN_NOTIFY_DECODE
> -The driver supports
> -.BR LIRC_NOTIFY_DECODE .
> -.TP
> -.BR LIRC_CAN_SEND_RAW
> -The driver supports sending using
> -.BR LIRC_MODE_RAW .
> -.TP
>   .BR LIRC_CAN_SEND_PULSE
>   The driver supports sending using
>   .BR LIRC_MODE_PULSE .
>   .TP
> -.BR LIRC_CAN_SEND_MODE2
> -The driver supports sending using
> -.BR LIRC_MODE_MODE2 .
> -.TP
>   .BR LIRC_CAN_SEND_LIRCCODE
>   The driver supports sending.
>   (This is uncommon, since
> 
