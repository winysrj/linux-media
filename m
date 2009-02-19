Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:50414 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZBSSTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 13:19:35 -0500
Received: from ozzy.localnet (dhpc-2-02.sissa.it [147.122.2.182])
	by smtp.sissa.it (Postfix) with ESMTP id 891591B480B9
	for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 19:19:33 +0100 (CET)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] dvb-spec: Use fancyhdr instead of obsolete fancyheadings
Date: Thu, 19 Feb 2009 19:19:36 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191919.36159.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LaTeX package fancyheadings is obsolete and superseded by fancyhdr.

Priority: normal

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
---
diff -r 7b7de23c81a1 -r 21ab77e356e1 dvb-spec/dvbapi/dvbapi.tex
--- a/dvb-spec/dvbapi/dvbapi.tex	Wed Feb 18 03:28:46 2009 +0100
+++ b/dvb-spec/dvbapi/dvbapi.tex	Wed Feb 18 18:27:33 2009 +0100
@@ -4,7 +4,7 @@
 \usepackage{times}
 
 %\usepackage[hang]{caption}
-\usepackage{fancyheadings}
+\usepackage{fancyhdr}
 %\usepackage{lucidabr}
 %\usepackage{fancybox}
 \usepackage{array}
@@ -24,82 +24,82 @@
 \newcommand{\function}[5]{
   \subsection{#1}
 
-  \noindent DESCRIPTION 
+  \noindent DESCRIPTION
   \medskip
-  
+
   \begin{tabular}[h]{p{11cm}}
     #3
   \end{tabular}
-  
+
   \medskip
-  \noindent SYNOPSIS 
+  \noindent SYNOPSIS
   \medskip
 
   \begin{tabular}[h]{p{11cm}}
     {\tt #2}
   \end{tabular}
-    
-  %\item[] 
+
+  %\item[]
 \medskip
-\noindent PARAMETERS 
+\noindent PARAMETERS
 \medskip
-    
+
     \begin{tabular}[h]{p{3cm}p{8cm}}
       #4
     \end{tabular}
-    
-  %\item[] 
+
+  %\item[]
 \medskip
 \noindent ERRORS
 \medskip
-    
+
     \begin{tabular}[h]{p{3cm}p{8cm}}
       #5
     \end{tabular}
-    
+
   %\end{itemize}
-  
+
 \medskip
 }
 \def\ifunction#1#2#3#4#5{\function{#1\index{#1}}{#2}{#3}{#4}{#5}}
 
 \newcommand{\kfunction}[5]{
   \subsection{#1}
-  \noindent DESCRIPTION 
+  \noindent DESCRIPTION
   \medskip
 
   \begin{tabular}[h]{p{11cm}}
     #3
   \end{tabular}
-  
+
   \medskip
-  \noindent SYNOPSIS 
+  \noindent SYNOPSIS
   \medskip
 
   \begin{tabular}[h]{p{11cm}}
     {\tt #2}
   \end{tabular}
-    
-  %\item[] 
+
+  %\item[]
 \medskip
-\noindent PARAMETERS 
+\noindent PARAMETERS
 \medskip
-    
+
     \begin{tabular}[h]{p{3cm}p{8cm}}
       #4
     \end{tabular}
-    
-  %\item[] 
+
+  %\item[]
 \medskip
 \noindent RETURNS
 \medskip
-    
+
     \begin{tabular}[h]{p{3cm}p{8cm}}
       #5
     \end{tabular}
-    
+
   %\end{itemize}
-  
+
 \medskip
 }
 \def\kifunction#1#2#3#4#5{\kfunction{#1\index{#1}}{#2}{#3}{#4}{#5}}
@@ -164,7 +164,7 @@
 
 \end{document}
 
-%%% Local Variables: 
+%%% Local Variables:
 %%% mode: latex
 %%% TeX-master: t
-%%% End: 
+%%% End:

