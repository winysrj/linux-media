Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41478 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751197AbZBVRjh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 12:39:37 -0500
Message-ID: <49A18DD5.40206@gmx.de>
Date: Sun, 22 Feb 2009 18:39:33 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-api: update documentation, chapter1
Content-Type: multipart/mixed;
 boundary="------------040606020909080605000305"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040606020909080605000305
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Since dvb-api doc is still outdated by six years...


The following patch changes dvbapi.pdf as following:
_______________________________________________________________________________

- change from twosided book format to singlesided book format.
  * By doing so, the readability is improved and on the right-hand side
    is more space on every second page.

- change copyright notice on first page by adding "2008, 2009 
www.linuxtv.org"

- add "The Linux DVB Developers http://www.linuxtv.org" to 'written by'

- increase API Version number to 5

- change Version Number and date
  -- 24/07/2003    V 1.0.0
  ++ 22/02/2009    Version 1.1.0 <- unstable version now, every time api 
is changed version should be increased now

- chapter 1 - What you need to know
   * added goal: "consistent abstraction layer for
     different digital TV hardware, allowing software applications to be
     developed without hardware details as well as serving as driver 
developers reference"
   * added comment: odd api version numbers = unstable -> not to be used 
for driver/app development

- chapter 1 - history
  * add History of DVB API v 4
  * add comment LinuxTV project beeing an independend and non-profit 
community
  * add reasons for DVB API v 5 and decision on Plumbers Conference 2008 
towards S2API

- chapter 1 - Overview
  * changed "DVB PCI card" wherever found, since API doesnt depend on 
PCI bus
  * changed "MPEG picture and sound decoding" to "MPEG video and audio 
decoding",
    since mpeg picture is misleading

- fix some typos inside chapter 1
- fix "Overfull \hbox" warnings from chapter 1 (*only* chapter 1 for now..)

Signed-off-by: Winfried Koehler <handygewinnspiel@gmx.de>
_______________________________________________________________________________

Please response, comment, improve, review, apply. Do not ignore silently,
having a new API doc should be hard requirement for next kernel versions.

Regards, Winfried







diff -Nrup v4l-dvb-359d95e1d541/dvb-spec/dvbapi/dvbapi.tex 
v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/dvbapi.tex
--- v4l-dvb-359d95e1d541/dvb-spec/dvbapi/dvbapi.tex    2009-02-22 
17:07:48.123742503 +0100
+++ v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/dvbapi.tex    2009-02-21 
17:33:29.557033066 +0100
@@ -1,4 +1,4 @@
-\documentclass[a4paper,10pt]{book}
+\documentclass[a4paper,10pt,oneside]{book}
 \usepackage[dvips,colorlinks=true]{hyperref}
 
 \usepackage{times}
diff -Nrup v4l-dvb-359d95e1d541/dvb-spec/dvbapi/intro.tex 
v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/intro.tex
--- v4l-dvb-359d95e1d541/dvb-spec/dvbapi/intro.tex    2009-02-18 
13:49:37.000000000 +0100
+++ v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/intro.tex    2009-02-22 
16:03:12.610230293 +0100
@@ -7,36 +7,73 @@
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
+For this API documentation applies an even/odd versioning scheme, stating
+unstable or stable versions of that API. Only stable API versions should
+be used for developing drivers and applications.
+\newpage
 \section{History}
 
-The first API for DVB cards we used at Convergence in late 1999
-was an extension of the Video4Linux API which was primarily
+The first API for DVB cards was used at Convergence in late 1999
+as an extension of the Video4Linux API which was primarily
 developed for frame grabber cards.
+
+
 As such it was not really well suited to be used for DVB cards and
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
+usually a budget card provides the full raw transport stream and decoding
+and processing is main CPU's task. On embedded platforms, however, data is
+multiplexed by specialized hardware or firmware for direct application use
+which relieves the main CPU from these tasks. Therefore, Linux DVB
+API Version 4 was suggested, but unfortunally never completed.
+
+
+Today, the LinuxTV project is an independend and non-profit community 
project
+by DVB/V4L enthusiasts and developers interested in Digital TV and 
Analog TV,
+sharing the same hg tree.
+
+However, this document describes only the digital TV part.
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
+This Linux DVB API documentation will be extended to reflect these 
additions.
 \newpage
 \section{Overview}
 
@@ -49,7 +86,7 @@ provides a first implementation of the L
 \end{figure}
 
 
-A DVB PCI card or DVB set-top-box (STB) usually consists of the following
+A DVB device or DVB set-top-box (STB) usually consists of the following
 main hardware components:
 \begin{itemize}
 \item Frontend consisting of tuner and DVB demodulator
@@ -85,10 +122,10 @@ a TV set.
 Figure \ref{fig:dvbstb} shows a crude schematic of the control and data 
flow
 between those components.
 
-On a DVB PCI card not all of these have to be present since some
-functionality can be provided by the main CPU of the PC (e.g. MPEG picture
-and sound decoding) or is not needed (e.g. for data-only uses like
-``internet over satellite'').
+On a DVB card not all of these have to be present since some
+functionality can be provided by the main CPU of the PC (e.g. MPEG video
+and audio decoding) or is not needed (e.g. for data-only uses like
+``internet over satellite''). In fact, almost all new DTV devices use 
the CPU for MPEG decoding.
 Also not every card or STB provides conditional access hardware.
 
 \section{Linux DVB Devices}
@@ -117,12 +154,11 @@ All devices can be found in the \texttt{
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
@@ -137,10 +173,13 @@ in application sources with a partial pa
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

 


--------------040606020909080605000305
Content-Type: text/plain;
 name="api_chapter1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="api_chapter1.diff"

diff -Nrup v4l-dvb-359d95e1d541/dvb-spec/dvbapi/dvbapi.tex v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/dvbapi.tex
--- v4l-dvb-359d95e1d541/dvb-spec/dvbapi/dvbapi.tex	2009-02-22 17:07:48.123742503 +0100
+++ v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/dvbapi.tex	2009-02-21 17:33:29.557033066 +0100
@@ -1,4 +1,4 @@
-\documentclass[a4paper,10pt]{book}
+\documentclass[a4paper,10pt,oneside]{book}
 \usepackage[dvips,colorlinks=true]{hyperref}
 
 \usepackage{times}
diff -Nrup v4l-dvb-359d95e1d541/dvb-spec/dvbapi/intro.tex v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/intro.tex
--- v4l-dvb-359d95e1d541/dvb-spec/dvbapi/intro.tex	2009-02-18 13:49:37.000000000 +0100
+++ v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/intro.tex	2009-02-22 16:03:12.610230293 +0100
@@ -7,36 +7,73 @@
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
+Various DVB standards documents are available from \texttt{http://www.dvb.org/}
+and/or \texttt{http://www.etsi.org/}.
 
 It is also necessary to know how to access unix/linux devices and how
 to use ioctl calls. This also includes the knowledge of C or C++.
 
+The goal of this API is to provide a consistent abstraction layer for 
+different digital TV hardware, allowing software applications to be
+developed without hardware details as well as serving as driver
+developers reference.
+
+For this API documentation applies an even/odd versioning scheme, stating
+unstable or stable versions of that API. Only stable API versions should
+be used for developing drivers and applications.
+\newpage
 \section{History}
 
-The first API for DVB cards we used at Convergence in late 1999
-was an extension of the Video4Linux API which was primarily 
+The first API for DVB cards was used at Convergence in late 1999
+as an extension of the Video4Linux API which was primarily 
 developed for frame grabber cards.
+
+
 As such it was not really well suited to be used for DVB cards and 
 their new features like recording MPEG streams and filtering several 
 section and PES data streams at the same time.
 
-In early 2000, we were approached by Nokia with a proposal for a new
+
+In early 2000, Convergence was approached by Nokia with a proposal for a new
 standard Linux DVB API.
 As a commitment to the development of terminals based on open standards, 
 Nokia and Convergence made it available to all Linux developers and
 published it on \texttt{http://www.linuxtv.org/} in September 2000.
-Convergence is the maintainer of the Linux DVB API.
-Together with the LinuxTV community (i.e. you, the reader of this document), 
-the Linux DVB API will be constantly reviewed and improved. 
-With the Linux driver for the Siemens/Hauppauge DVB PCI card Convergence 
-provides a first implementation of the Linux DVB API.
 
 
+In 2003 Convergence and Toshiba Electronics Europe GmbH started the development
+of 
+\href {http://www.linuxtv.org/downloads/linux-dvb-api-v4/linux-dvb-api-v4-0-3.pdf}{DVB API Version 4} 
+with public discussion on the linux-dvb mailing list. The goal was a complete 
+new API, reflecting that PCs and embedded platforms are diverging. On a PC 
+usually a budget card provides the full raw transport stream and decoding 
+and processing is main CPU's task. On embedded platforms, however, data is
+multiplexed by specialized hardware or firmware for direct application use 
+which relieves the main CPU from these tasks. Therefore, Linux DVB
+API Version 4 was suggested, but unfortunally never completed.
+
+
+Today, the LinuxTV project is an independend and non-profit community project
+by DVB/V4L enthusiasts and developers interested in Digital TV and Analog TV,
+sharing the same hg tree.
+
+However, this document describes only the digital TV part.
+
+
+With the further development of newer DTV standards, the existing version
+3 of the Linux DVB API was no longer able to support all DTV standards and
+newer hardware. Two concurrent approaches to overcome the problem where
+proposed, \texttt{Multiproto} and \texttt{S2API}.
+
+At 
+\href {http://www.linuxtv.org/news.php?entry=2008-09-19.mchehab}{Linux Plumbers Conference 2008} 
+the decision was made towards to S2API, basically an extension to
+\texttt{DVB API Version 3} called \texttt{DVB API Version 5}.
+
+
+This Linux DVB API documentation will be extended to reflect these additions.
 \newpage
 \section{Overview}
 
@@ -49,7 +86,7 @@ provides a first implementation of the L
 \end{figure}
 
 
-A DVB PCI card or DVB set-top-box (STB) usually consists of the following
+A DVB device or DVB set-top-box (STB) usually consists of the following
 main hardware components:
 \begin{itemize}
 \item Frontend consisting of tuner and DVB demodulator
@@ -85,10 +122,10 @@ a TV set.
 Figure \ref{fig:dvbstb} shows a crude schematic of the control and data flow 
 between those components.
 
-On a DVB PCI card not all of these have to be present since some 
-functionality can be provided by the main CPU of the PC (e.g. MPEG picture
-and sound decoding) or is not needed (e.g. for data-only uses like 
-``internet over satellite'').
+On a DVB card not all of these have to be present since some 
+functionality can be provided by the main CPU of the PC (e.g. MPEG video
+and audio decoding) or is not needed (e.g. for data-only uses like 
+``internet over satellite''). In fact, almost all new DTV devices use the CPU for MPEG decoding.
 Also not every card or STB provides conditional access hardware.
 
 \section{Linux DVB Devices}
@@ -117,12 +154,11 @@ All devices can be found in the \texttt{
 \item \texttt{/dev/dvb/adapterN/demuxM},
 \item \texttt{/dev/dvb/adapterN/caM},
 \end{itemize}
-where N enumerates the DVB PCI cards in a system starting from~0,
+where N enumerates the DVB adapters (pci cards, usb devices, ..) in a system starting from~0,
 and M enumerates the devices of each type within each adapter, starting
 from~0, too.
 We will omit the ``\texttt{/dev/dvb/adapterN/}'' in the further dicussion of 
-these devices.  The naming scheme for the devices is the same wheter devfs
-is used or not.
+these devices.
 
 More details about the data structures and function calls of 
 all the devices are described in the following chapters.
@@ -137,10 +173,13 @@ in application sources with a partial pa
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
diff -Nrup v4l-dvb-359d95e1d541/dvb-spec/dvbapi/title.tex v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/title.tex
--- v4l-dvb-359d95e1d541/dvb-spec/dvbapi/title.tex	2009-02-18 13:49:37.000000000 +0100
+++ v4l-dvb-a7ea3df69673/dvb-spec/dvbapi/title.tex	2009-02-22 09:33:54.766093761 +0100
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
 

--------------040606020909080605000305--
