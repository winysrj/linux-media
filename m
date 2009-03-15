Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752657AbZCOLeS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 07:34:18 -0400
Message-ID: <49BCE7B5.1030607@gmx.de>
Date: Sun, 15 Mar 2009 12:34:13 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH] dvb-api: update documentation, chapter1 (Resubmit)
References: <49A18DD5.40206@gmx.de>	<20090226121445.74ed3202@caramujo.chehab.org>	<49A6EB4D.70208@gmx.de> <20090314090020.5b041c00@pedra.chehab.org>
In-Reply-To: <20090314090020.5b041c00@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab schrieb:
> Hi wk,
>
> Let's commit what we currently have. Could you please re-submit the patch
> again, this time providing a proper description, and your SOB?
>
> Cheers,
> Mauro.
>   
The attached patch provides the following changes to DVB API:
- files changed
      - dvbapi.tex
      - intro.tex
      - title.tex

- change page format from "twosided book" to "onesided book" to improve 
readability
- fix several latex compiling warnings "Overfull \hbox" due to too long 
lines.
- replace in chapter 1 all occurrencies of "DVB PCI card" with "DVB device"

- change First Page:
      - add "and The Linux DVB developers" to Copyright
      - add "2008, 2009 www.linuxtv.org" to Copyright
      - change version and date to "22/02/2009 Version 1.1.0"

- change Chapter 1, Section 1.2 History:
      - remove line that Convergence is maintainer of doc, since in fact 
linuxtv.org is currently maintaining it.
      - remove line "Together with the LinuxTV community (i.e. you, the 
reader of this document),
                    the Linux DVB API will be constantly reviewed and 
improved."
      - remove line "With the Linux driver for the Siemens/Hauppauge DVB 
PCI card Convergence
                     provides a first implementation of the Linux DVB API"
      - add comment about neither completed, nor implemented DVB API v4
      - add comment about being project independent and non-profit
      - add comment describing digital part only and cross-reference to 
V4L2 API on linuxtv
      - add comment about need for API extension for newer DTV standards
      - add comment about Multiproto and S2API and decision on plumbers 
conference 2k8
      - add comment about version now called v5

- change Chapter 1, Section 1.3 Overview:
      -  change "MPEG picture and sound decoding" to "MPEG video and 
audio decoding"

- change Chapter 1, Section 1.4 Linux DVB Devices
      -  remove reference to no longer used devfs

- change Chapter 1, Section 1.5 API include files
      -  fix typo: "to support different API version" -> "to support 
different API versions"
      -  add "Since API version 5 an API command for quering API version 
also exists,
                    allowing user space applications to detect API 
version during runtime"

          =>  see also:   
http://www.linuxtv.org/news.php?entry=2008-09-23.mchehab
                  "Adding an API command for querying DVB version, to 
allow an easier detection by userspaceapplications"


Signed-off-by: Winfried Koehler <handygew...@gmx.de>

---------------------------------------------------------------------------- 

diff -Nurp v4l-dvb-17554cc18063/dvb-spec/dvbapi/dvbapi.tex 
v4l-dvb-17554cc18063_1/dvb-spec/dvbapi/dvbapi.tex
--- v4l-dvb-17554cc18063/dvb-spec/dvbapi/dvbapi.tex    2009-02-23 
16:26:38.000000000 +0100
+++ v4l-dvb-17554cc18063_1/dvb-spec/dvbapi/dvbapi.tex    2009-02-26 
18:40:35.008186330 +0100
@@ -1,4 +1,4 @@
-\documentclass[a4paper,10pt]{book}
+\documentclass[a4paper,10pt,oneside]{book}
 \usepackage[dvips,colorlinks=true]{hyperref}
 
 \usepackage{times}
diff -Nurp v4l-dvb-17554cc18063/dvb-spec/dvbapi/intro.tex 
v4l-dvb-17554cc18063_1/dvb-spec/dvbapi/intro.tex
--- v4l-dvb-17554cc18063/dvb-spec/dvbapi/intro.tex    2009-02-23 
16:26:38.000000000 +0100
+++ v4l-dvb-17554cc18063_1/dvb-spec/dvbapi/intro.tex    2009-02-26 
20:04:57.245819770 +0100
@@ -7,49 +7,84 @@
 The reader of this document is required to have some knowledge in the
 area of digital video broadcasting (DVB) and should be familiar with
 part I of the MPEG2 specification ISO/IEC 13818 (aka ITU-T H.222),
-i.e you should know what a program/transport stream (PS/TS) is and what is
-meant by a packetized elementary stream (PES) or an I-frame.
-
-Various DVB standards documents are available from
-\texttt{http://www.dvb.org/} and/or \texttt{http://www.etsi.org/}.
+i.e you should know what a program stream or transport stream (PS/TS) is
+and what is meant by a packetized elementary stream (PES) or an I-frame.
+Various DVB standards documents are available from 
\texttt{http://www.dvb.org/}
+and/or \texttt{http://www.etsi.org/}.
 
 It is also necessary to know how to access unix/linux devices and how
 to use ioctl calls. This also includes the knowledge of C or C++.
 
+The goal of this API is to provide a consistent abstraction layer for
+different digital TV hardware, allowing software applications to be
+developed without hardware details as well as serving as driver
+developers reference.
+
+\newpage
 \section{History}
 
-The first API for DVB cards we used at Convergence in late 1999
-was an extension of the Video4Linux API which was primarily
-developed for frame grabber cards.
-As such it was not really well suited to be used for DVB cards and
+The first API for DVB devices was used at Convergence in late 1999
+as an extension of the Video4Linux API which was primarily
+developed for frame grabber devices.
+
+
+As such it was not really well suited to be used for DVB devices and
 their new features like recording MPEG streams and filtering several
 section and PES data streams at the same time.
 
-In early 2000, we were approached by Nokia with a proposal for a new
+
+In early 2000, Convergence was approached by Nokia with a proposal for 
a new
 standard Linux DVB API.
 As a commitment to the development of terminals based on open standards,
 Nokia and Convergence made it available to all Linux developers and
 published it on \texttt{http://www.linuxtv.org/} in September 2000.
-Convergence is the maintainer of the Linux DVB API.
-Together with the LinuxTV community (i.e. you, the reader of this 
document),
-the Linux DVB API will be constantly reviewed and improved.
-With the Linux driver for the Siemens/Hauppauge DVB PCI card Convergence
-provides a first implementation of the Linux DVB API.
 
 
+In 2003 Convergence and Toshiba Electronics Europe GmbH started the 
development
+of
+\href 
{http://www.linuxtv.org/downloads/linux-dvb-api-v4/linux-dvb-api-v4-0-3.pdf}{DVB 
API Version 4}
+with public discussion on the linux-dvb mailing list. The goal was a 
complete
+new API, reflecting that PCs and embedded platforms are diverging. On a PC
+usually a budget device provides the full raw transport stream and 
decoding
+and processing is main CPU's task. On embedded platforms, however, data is
+multiplexed by specialized hardware or firmware for direct application use
+which relieves the main CPU from these tasks. Therefore, Linux DVB
+API Version 4 was suggested but neither completed, nor implemented.
+
+
+Today, the LinuxTV project is an independent and non-profit community 
project
+by DVB/V4L enthusiasts and developers interested in Digital TV and 
Analog TV,
+sharing the same hg tree.
+
+This document describes the digital TV API. For Analog TV and radio, 
please consult
+\href{http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/v4l2spec/v4l2.pdf}{V4L2 
API}.
+
+
+With the further development of newer DTV standards, the existing version
+3 of the Linux DVB API was no longer able to support all DTV standards and
+newer hardware. Two concurrent approaches to overcome the problem where
+proposed, \texttt{Multiproto} and \texttt{S2API}.
+
+At
+\href {http://www.linuxtv.org/news.php?entry=2008-09-19.mchehab}{Linux 
Plumbers Conference 2008}
+the decision was made towards to S2API, basically an extension to
+\texttt{DVB API Version 3} called \texttt{DVB API Version 5}.
+
+
+This document is currently under review to reflect the S2API additions.
 \newpage
 \section{Overview}
 
 \begin{figure}[htbp]
   \begin{center}
     \includegraphics{dvbstb.ps}
-    \caption{Components of a DVB card/STB}
+    \caption{Components of a DVB device/STB}
     \label{fig:dvbstb}
   \end{center}
 \end{figure}
 
 
-A DVB PCI card or DVB set-top-box (STB) usually consists of the following
+A DVB device or DVB set-top-box (STB) usually consists of the following
 main hardware components:
 \begin{itemize}
 \item Frontend consisting of tuner and DVB demodulator
@@ -85,11 +120,11 @@ a TV set.
 Figure \ref{fig:dvbstb} shows a crude schematic of the control and data 
flow
 between those components.
 
-On a DVB PCI card not all of these have to be present since some
-functionality can be provided by the main CPU of the PC (e.g. MPEG picture
-and sound decoding) or is not needed (e.g. for data-only uses like
-``internet over satellite'').
-Also not every card or STB provides conditional access hardware.
+On a DVB device not all of these have to be present since some
+functionality can be provided by the main CPU of the PC (e.g. MPEG video
+and audio decoding) or is not needed (e.g. for data-only uses like
+``internet over satellite''). In fact, almost all new DTV devices use 
the CPU for MPEG decoding.
+Also not every device or STB provides conditional access hardware.
 
 \section{Linux DVB Devices}
 
@@ -117,12 +152,11 @@ All devices can be found in the \texttt{
 \item \texttt{/dev/dvb/adapterN/demuxM},
 \item \texttt{/dev/dvb/adapterN/caM},
 \end{itemize}
-where N enumerates the DVB PCI cards in a system starting from~0,
+where N enumerates the DVB adapters (pci cards, usb devices, ..) in a 
system starting from~0,
 and M enumerates the devices of each type within each adapter, starting
 from~0, too.
 We will omit the ``\texttt{/dev/dvb/adapterN/}'' in the further 
dicussion of
-these devices.  The naming scheme for the devices is the same wheter devfs
-is used or not.
+these devices.
 
 More details about the data structures and function calls of
 all the devices are described in the following chapters.
@@ -137,10 +171,13 @@ in application sources with a partial pa
 #include <linux/dvb/frontend.h>
 \end{verbatim}
 
-To enable applications to support different API version, an additional
+To enable applications to support different API versions, an additional
 include file \texttt{linux/dvb/version.h} exists, which defines the
 constant \texttt{DVB\_API\_VERSION}. This document describes
-\texttt{DVB\_API\_VERSION~3}.
+\texttt{DVB\_API\_VERSION~5}.
+
+Since API version 5 an API command for quering API version also exists,
+allowing user space applications to detect API version during runtime.
 
 %%% Local Variables:
 %%% mode: latex
diff -Nurp v4l-dvb-17554cc18063/dvb-spec/dvbapi/title.tex 
v4l-dvb-17554cc18063_1/dvb-spec/dvbapi/title.tex
--- v4l-dvb-17554cc18063/dvb-spec/dvbapi/title.tex    2009-02-23 
16:26:38.000000000 +0100
+++ v4l-dvb-17554cc18063_1/dvb-spec/dvbapi/title.tex    2009-02-26 
18:40:35.008186330 +0100
@@ -1,16 +1,20 @@
 \pagenumbering{arabic}
 \pagestyle{empty}
-\title{\huge\textbf{LINUX DVB API Version 3}}
+\title{\huge\textbf{LINUX DVB API Version 5}}
 
 \author{
 \includegraphics{cimlogo.psi}\\
-  Copyright 2002, 2003 Convergence GmbH\\\\
+  Copyright:\\
+  2002, 2003 Convergence GmbH,\\
+  2008, 2009 www.linuxtv.org\\\\
   Written by Dr. Ralph J.K. Metzler\\
-  \texttt{<rjkm@metzlerbros.de>}\\\\
+  \texttt{<rjkm@metzlerbros.de>}\\
   and Dr. Marcus O.C. Metzler\\
-  \texttt{<mocm@metzlerbros.de>}\\
+  \texttt{<mocm@metzlerbros.de>},\\
+  and The Linux DVB developers\\
+  \texttt{http://www.linuxtv.org}\\\\
 }
-\date{24/07/2003\\V 1.0.0}
+\date{22/02/2009\\Version 1.1.0}
 
 \maketitle
 








