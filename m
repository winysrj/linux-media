Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JsGz2-0002tl-Iv
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 14:36:57 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 3 May 2008 14:35:59 +0200
References: <481A3D61.7040508@googlemail.com>
In-Reply-To: <481A3D61.7040508@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805031435.59693@orion.escape-edv.de>
Cc: Andrea <mariofutire@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] Synchronize dvb-apps with v4l-dvb
Reply-To: linux-dvb@linuxtv.org
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

Andrea wrote:
> Hi,
> 
> This patch (posted for the 3rd times) keeps dvb-apps in line with recent (and not so recent) changes 
> in v4l-dvb:
> 
> 1) for 2 years it has not been possible to open the dvr more than once for read only.
> After this change http://linuxtv.org/hg/v4l-dvb/rev/64edfcc88eeb the dvr can only be opened once.
> The patch fixes a comment to the function dvbdemux_open_dvr
> 
> 2) this changeset http://linuxtv.org/hg/v4l-dvb/rev/65699e8bc6f7 added the option 
> DMX_OUT_TSDEMUX_TAP to send the TS to the demux.
> The patch enhances dvbdemux.h to use the DMX_OUT_TSDEMUX_TAP
> 
> 3) a recent changest http://linuxtv.org/hg/v4l-dvb/rev/8389fb4e774c implemented DMX_SET_BUFFER for 
> the dvr.
> tzap used to set the dvr buffer size to 1MB (this ioctl call used to be ignored) while the default 
> size is actually double (~2MB). I think the aim of the code was to make the buffer bigger and not to 
> shrink it. That buffer in my opinion should stay as it is.

Committed to dvb-apps. Thanks.

Btw, I also committed this patch to make dvbdemux.c compile against
current kernel headers:

+++ b/lib/libdvbapi/dvbdemux.c	Sat May 03 14:26:59 2008 +0200
@@ -128,9 +128,11 @@ int dvbdemux_set_pes_filter(int fd, int 
 		filter.output = DMX_OUT_TS_TAP;
 		break;
 
+#ifdef DMX_OUT_TSDEMUX_TAP
 	case DVBDEMUX_OUTPUT_TS_DEMUX:
 		filter.output = DMX_OUT_TSDEMUX_TAP;
 		break;
+#endif
 
 	default:
 		return -EINVAL;
@@ -205,9 +207,11 @@ int dvbdemux_set_pid_filter(int fd, int 
 		filter.output = DMX_OUT_TS_TAP;
 		break;
 
+#ifdef DMX_OUT_TSDEMUX_TAP
 	case DVBDEMUX_OUTPUT_TS_DEMUX:
 		filter.output = DMX_OUT_TSDEMUX_TAP;
 		break;
+#endif
 
 	default:
 		return -EINVAL;

> I've posted this patch 3 times already with 0 (i.e. ZERO) replies.
> Is there anybody taking care of dvb-apps?

Sorry, dvb-apps is more or less unmaintained.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
