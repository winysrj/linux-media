Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaBZKU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 05:20:26 -0500
From: "Ryan, Mark D" <mark.d.ryan@intel.com>
To: "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Dell XPS 12 USB camera bulk mode issues
Date: Wed, 26 Feb 2014 10:20:06 +0000
Message-ID: <EBD828E1B55D6A41B9BA1EEC16778B3B2F26CC95@IRSMSX101.ger.corp.intel.com>
References: <20140225214956.GC4035@xanatos>
In-Reply-To: <20140225214956.GC4035@xanatos>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Sharp, Sarah A
> Sent: Tuesday, February 25, 2014 10:50 PM
> To: Laurent Pinchart; Mauro Carvalho Chehab
> Cc: linux-media@vger.kernel.org; Ryan, Mark D
> Subject: Dell XPS 12 USB camera bulk mode issues
> 
> Hi Laurent and Mauro,
> 
> Mark has running into issues with the Realtek integrated webcam on a Dell
> XPS 12 system that uses bulk endpoints.  The webcam shows visible glitches
> with certain resolutions (stripes of frame missing, distorted images, purple and
> green colors, blank image, or missing the bottom half of the image).
> 

 [Ryan, Mark D] 

Sarah, thanks for the introduction.

I can provide a little bit more information.

1. I've tried all the UVC driver quirks but none of these seem to help.

2. I've also run some tests with the UVC traces enabled.  There are quite a lot of errors.  I include a portion of the logs below.  They were generated on Ubuntu 13.10 (linux 3.11.0-12) running guvcview recording YVUV 1280x720 at 10fps.

[   80.490256] uvcvideo: Frame complete (FID bit toggled).
[   80.490262] uvcvideo: frame 2080 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2069725020/32605
[   80.490264] uvcvideo: Marking buffer as bad (error bit set).
[   80.490606] uvcvideo: Frame complete (EOF found).
[   80.490942] uvcvideo: Marking buffer as bad (error bit set).
[   80.490947] uvcvideo: Dropping payload (out of sync).
[   80.492920] uvcvideo: Marking buffer as bad (error bit set).
[   80.492927] uvcvideo: Dropping payload (out of sync).
[   80.495352] uvcvideo: frame 2081 stats: 0/0/3 packets, 0/0/1 pts (!early !initial), 2/3 scr, last pts/stc/sof 2103017049/2069659484/32604
[   80.495360] uvcvideo: Marking buffer as bad (error bit set).
[   80.496066] uvcvideo: Marking buffer as bad (error bit set).
[   80.498021] uvcvideo: frame 2082 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2103148379/2103148379/32601
[   80.498030] uvcvideo: Marking buffer as bad (error bit set).
[   80.498033] uvcvideo: Frame complete (FID bit toggled).
[   80.498039] uvcvideo: frame 2083 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2103213661/2103213661/32349
[   80.498042] uvcvideo: Marking buffer as bad (error bit set).
[   80.500420] uvcvideo: Marking buffer as bad (error bit set).
[   80.501122] uvcvideo: Marking buffer as bad (error bit set).
[   80.502742] uvcvideo: Frame complete (EOF found).
[   80.503095] uvcvideo: frame 2084 stats: 0/0/3 packets, 1/1/2 pts (!early initial), 2/3 scr, last pts/stc/sof 2102754899/2069659484/32604
[   80.503100] uvcvideo: Marking buffer as bad (error bit set).
[   80.505510] uvcvideo: Marking buffer as bad (error bit set).
[   80.505890] uvcvideo: Frame complete (EOF found).
[   80.506245] uvcvideo: frame 2085 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2119532118/2119532118/32341
[   80.506249] uvcvideo: Marking buffer as bad (error bit set).
[   80.507845] uvcvideo: Frame complete (EOF found).
[   80.508187] uvcvideo: Marking buffer as bad (error bit set).
[   80.508191] uvcvideo: Dropping payload (out of sync).
[   80.510747] uvcvideo: frame 2086 stats: 0/0/2 packets, 0/0/1 pts (!early initial), 1/2 scr, last pts/stc/sof 2137357669/2085781330/32594
[   80.510752] uvcvideo: Marking buffer as bad (error bit set).
[   80.511463] uvcvideo: frame 2087 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2081456144/2081456144/32784
[   80.511471] uvcvideo: Marking buffer as bad (error bit set).
[   80.511474] uvcvideo: Frame complete (FID bit toggled).
[   80.511480] uvcvideo: frame 2088 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102493775/2102559313/33362
[   80.511483] uvcvideo: Marking buffer as bad (error bit set).
[   80.513895] uvcvideo: frame 2089 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102493775/2102559313/33362
[   80.513904] uvcvideo: Marking buffer as bad (error bit set).
[   80.513907] uvcvideo: Frame complete (FID bit toggled).
[   80.513913] uvcvideo: frame 2090 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2086567773/2086502238/32605
[   80.513916] uvcvideo: Marking buffer as bad (error bit set).
[   80.514608] uvcvideo: frame 2091 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2086567773/2086502238/32605
[   80.514617] uvcvideo: Marking buffer as bad (error bit set).
[   80.514620] uvcvideo: Frame complete (FID bit toggled).
[   80.514626] uvcvideo: frame 2092 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102754901/2102754901/32341
[   80.514629] uvcvideo: Marking buffer as bad (error bit set).
[   80.517141] uvcvideo: Marking buffer as bad (error bit set).
[   80.517858] uvcvideo: Marking buffer as bad (error bit set).
[   80.520396] uvcvideo: frame 2093 stats: 0/0/3 packets, 2/2/3 pts (!early initial), 2/3 scr, last pts/stc/sof 2098429971/2098692119/32792
[   80.520404] uvcvideo: Marking buffer as bad (error bit set).
[   80.520407] uvcvideo: Frame complete (FID bit toggled).
[   80.520413] uvcvideo: frame 2094 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2081456656/2081456656/33296
[   80.520416] uvcvideo: Marking buffer as bad (error bit set).
[   80.521111] uvcvideo: frame 2095 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2081456656/2081456656/33296
[   80.521119] uvcvideo: Marking buffer as bad (error bit set).
[   80.521122] uvcvideo: Frame complete (FID bit toggled).
[   80.521128] uvcvideo: frame 2096 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102951768/2102820696/32598
[   80.521131] uvcvideo: Marking buffer as bad (error bit set).
[   80.523496] uvcvideo: frame 2097 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102951768/2102820696/32598
[   80.523505] uvcvideo: Marking buffer as bad (error bit set).
[   80.523508] uvcvideo: Frame complete (FID bit toggled).
[   80.523514] uvcvideo: frame 2098 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2119794008/2119728472/32088
[   80.523517] uvcvideo: Marking buffer as bad (error bit set).
[   80.523831] uvcvideo: Frame complete (EOF found).
[   80.525463] uvcvideo: Dropping payload (out of sync).
[   80.526190] uvcvideo: frame 2099 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 96354447/97436625/437
[   80.526199] uvcvideo: Marking buffer as bad (error bit set).
[   80.528590] uvcvideo: Marking buffer as bad (error bit set).
[   80.530563] uvcvideo: Marking buffer as bad (error bit set).
[   80.531249] uvcvideo: frame 2100 stats: 0/0/3 packets, 2/2/3 pts (!early initial), 2/3 scr, last pts/stc/sof 2102558546/2102624083/32595
[   80.531258] uvcvideo: Marking buffer as bad (error bit set).
[   80.531261] uvcvideo: Frame complete (FID bit toggled).
[   80.531267] uvcvideo: frame 2101 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2119401555/2119401555/32851
[   80.531270] uvcvideo: Marking buffer as bad (error bit set).
[   80.533319] uvcvideo: Frame complete (EOF found).
[   80.533683] uvcvideo: frame 2102 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2119401555/2119401555/32851
[   80.533692] uvcvideo: Marking buffer as bad (error bit set).
[   80.535641] uvcvideo: Marking buffer as bad (error bit set).
[   80.536353] uvcvideo: Marking buffer as bad (error bit set).
[   80.538778] uvcvideo: frame 2103 stats: 0/0/3 packets, 2/2/3 pts (!early initial), 2/3 scr, last pts/stc/sof 2102361937/2102361935/32591
[   80.538787] uvcvideo: Marking buffer as bad (error bit set).
[   80.538790] uvcvideo: Frame complete (FID bit toggled).
[   80.538796] uvcvideo: frame 2104 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2117435189/2100657973/32567
[   80.538799] uvcvideo: Marking buffer as bad (error bit set).
[   80.539116] uvcvideo: Frame complete (EOF found).
[   80.540751] uvcvideo: Marking buffer as bad (error bit set).
[   80.540758] uvcvideo: Dropping payload (out of sync).
[   80.542582] uvcvideo: frame 2105 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2119270481/2119336018/32850
[   80.542593] uvcvideo: Marking buffer as bad (error bit set).
[   80.543286] uvcvideo: Marking buffer as bad (error bit set).
[   80.545268] uvcvideo: Marking buffer as bad (error bit set).
[   80.547699] uvcvideo: frame 2106 stats: 0/0/3 packets, 2/2/3 pts (!early initial), 2/3 scr, last pts/stc/sof 2101378880/2101247806/32574
[   80.547707] uvcvideo: Marking buffer as bad (error bit set).
[   80.547710] uvcvideo: Frame complete (FID bit toggled).
[   80.547716] uvcvideo: frame 2107 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2118811466/2101903434/32840
[   80.547719] uvcvideo: Marking buffer as bad (error bit set).
[   80.548047] uvcvideo: Frame complete (EOF found).
[   80.548394] uvcvideo: Marking buffer as bad (error bit set).
[   80.548401] uvcvideo: Dropping payload (out of sync).
[   80.550362] uvcvideo: frame 2108 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2085125960/2085060423/32582
[   80.550371] uvcvideo: Marking buffer as bad (error bit set).
[   80.552830] uvcvideo: Marking buffer as bad (error bit set).
[   80.553372] uvcvideo: Marking buffer as bad (error bit set).
[   80.561825] uvcvideo: Marking buffer as bad (error bit set).
[   80.562162] uvcvideo: Frame complete (EOF found).
[   80.562497] uvcvideo: Marking buffer as bad (error bit set).
[   80.562505] uvcvideo: Dropping payload (out of sync).
[   80.564927] uvcvideo: frame 2109 stats: 0/0/6 packets, 3/3/4 pts (!early initial), 5/6 scr, last pts/stc/sof 97857347/2068480074/32842
[   80.564935] uvcvideo: Marking buffer as bad (error bit set).
[   80.566925] uvcvideo: frame 2110 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2069069907/2069069907/32851
[   80.566934] uvcvideo: Marking buffer as bad (error bit set).
[   80.566937] uvcvideo: Frame complete (FID bit toggled).
[   80.566943] uvcvideo: frame 2111 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102558546/2102493009/32593
[   80.566946] uvcvideo: Marking buffer as bad (error bit set).
[   80.567599] uvcvideo: frame 2112 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102558546/2102493009/32593
[   80.567607] uvcvideo: Frame complete (FID bit toggled).
[   80.567613] uvcvideo: frame 2113 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[   80.570041] uvcvideo: frame 2114 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[   80.570050] uvcvideo: Marking buffer as bad (error bit set).
[   80.570053] uvcvideo: Frame complete (FID bit toggled).
[   80.570059] uvcvideo: frame 2115 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2068938833/32849
[   80.570062] uvcvideo: Marking buffer as bad (error bit set).
[   80.570379] uvcvideo: Frame complete (EOF found).
[   80.572032] uvcvideo: frame 2116 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2068938833/32849
[   80.572041] uvcvideo: Marking buffer as bad (error bit set).
[   80.572713] uvcvideo: Marking buffer as bad (error bit set).
[   80.575138] uvcvideo: Marking buffer as bad (error bit set).
[   80.577804] uvcvideo: frame 2117 stats: 0/0/4 packets, 2/2/3 pts (!early initial), 2/3 scr, last pts/stc/sof 2084667459/2084470848/32830
[   80.577813] uvcvideo: Marking buffer as bad (error bit set).
[   80.577816] uvcvideo: Frame complete (FID bit toggled).
[   80.577822] uvcvideo: frame 2118 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2069004371/32851
[   80.577825] uvcvideo: Marking buffer as bad (error bit set).
[   80.578143] uvcvideo: Frame complete (EOF found).
[   80.580219] uvcvideo: Marking buffer as bad (error bit set).
[   80.580223] uvcvideo: Dropping payload (out of sync).
[   80.582212] uvcvideo: frame 2119 stats: 0/0/2 packets, 0/0/0 pts (!early !initial), 1/2 scr, last pts/stc/sof 0/2069266518/32854
[   80.582221] uvcvideo: Marking buffer as bad (error bit set).
[   80.582896] uvcvideo: frame 2120 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2086371163/2086371163/32604
[   80.582904] uvcvideo: Marking buffer as bad (error bit set).
[   80.582907] uvcvideo: Frame complete (FID bit toggled).
[   80.582913] uvcvideo: frame 2121 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102951768/2102951768/32600
[   80.582916] uvcvideo: Marking buffer as bad (error bit set).
[   80.584748] uvcvideo: Marking buffer as bad (error bit set).
[   80.586723] uvcvideo: frame 2122 stats: 0/0/2 packets, 0/0/1 pts (!early initial), 1/2 scr, last pts/stc/sof 2102951768/2036039771/32859
[   80.586731] uvcvideo: Marking buffer as bad (error bit set).
[   80.586734] uvcvideo: Frame complete (FID bit toggled).
[   80.586740] uvcvideo: frame 2123 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2052489304/32856
[   80.586743] uvcvideo: Marking buffer as bad (error bit set).
[   80.587067] uvcvideo: Frame complete (EOF found).
[   80.588555] uvcvideo: Marking buffer as bad (error bit set).
[   80.588564] uvcvideo: Dropping payload (out of sync).
[   80.590556] uvcvideo: Marking buffer as bad (error bit set).
[   80.590564] uvcvideo: Dropping payload (out of sync).
[   80.591231] uvcvideo: Marking buffer as bad (error bit set).
[   80.591239] uvcvideo: Dropping payload (out of sync).
[   80.593662] uvcvideo: frame 2124 stats: 0/0/4 packets, 2/3/3 pts (!early !initial), 3/4 scr, last pts/stc/sof 2086240088/2086240089/32601
[   80.593670] uvcvideo: Marking buffer as bad (error bit set).
[   80.593995] uvcvideo: Frame complete (EOF found).
[   80.595639] uvcvideo: Marking buffer as bad (error bit set).
[   80.595646] uvcvideo: Dropping payload (out of sync).
[   80.596344] uvcvideo: frame 2125 stats: 0/0/2 packets, 0/0/1 pts (!early !initial), 1/2 scr, last pts/stc/sof 2081456144/2081456144/32784
[   80.596353] uvcvideo: Marking buffer as bad (error bit set).
[   80.598768] uvcvideo: frame 2126 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2086371161/2086240091/32601
[   80.598776] uvcvideo: Marking buffer as bad (error bit set).
[   80.598779] uvcvideo: Frame complete (FID bit toggled).
[   80.598785] uvcvideo: frame 2127 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2103213916/2103279453/32605
[   80.598788] uvcvideo: Marking buffer as bad (error bit set).
[   80.600741] uvcvideo: frame 2128 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2103213916/2103279453/32605
[   80.600749] uvcvideo: Marking buffer as bad (error bit set).
[   80.600753] uvcvideo: Frame complete (FID bit toggled).
[   80.600758] uvcvideo: frame 2129 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102755157/2102624085/32595
[   80.600761] uvcvideo: Marking buffer as bad (error bit set).
[   80.601436] uvcvideo: Marking buffer as bad (error bit set).
[   80.603280] uvcvideo: frame 2130 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2086502237/2086502237/32605
[   80.603288] uvcvideo: Marking buffer as bad (error bit set).
[   80.603291] uvcvideo: Frame complete (FID bit toggled).
[   80.603297] uvcvideo: frame 2131 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2066711095/33331
[   80.603300] uvcvideo: Marking buffer as bad (error bit set).
[   80.604922] uvcvideo: Frame complete (EOF found).
[   80.605261] uvcvideo: frame 2132 stats: 0/0/1 packets, 0/0/0 pts (!early !initial), 0/1 scr, last pts/stc/sof 0/2066711095/33331
[   80.605270] uvcvideo: Marking buffer as bad (error bit set).
[   80.605627] uvcvideo: Frame complete (EOF found).
[   80.605982] uvcvideo: frame 2133 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2119532117/2119597654/32342
[   80.605990] uvcvideo: Marking buffer as bad (error bit set).
[   80.608029] uvcvideo: Frame complete (EOF found).
[   80.608384] uvcvideo: Marking buffer as bad (error bit set).
[   80.608391] uvcvideo: Dropping payload (out of sync).
[   80.610344] uvcvideo: Marking buffer as bad (error bit set).
[   80.610353] uvcvideo: Dropping payload (out of sync).
[   80.612192] uvcvideo: Marking buffer as bad (error bit set).
[   80.612196] uvcvideo: Dropping payload (out of sync).
[   80.612941] uvcvideo: Marking buffer as bad (error bit set).
[   80.612948] uvcvideo: Dropping payload (out of sync).
[   80.615462] uvcvideo: Marking buffer as bad (error bit set).
[   80.615469] uvcvideo: Dropping payload (out of sync).
[   80.616182] uvcvideo: Marking buffer as bad (error bit set).
[   80.616190] uvcvideo: Dropping payload (out of sync).
[   80.618717] uvcvideo: frame 2134 stats: 0/0/7 packets, 4/6/5 pts (!early initial), 6/7 scr, last pts/stc/sof 2102296398/2102165324/32588
[   80.618726] uvcvideo: Marking buffer as bad (error bit set).
[   80.619425] uvcvideo: Marking buffer as bad (error bit set).
[   80.621815] uvcvideo: frame 2135 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2081456656/2081456656/33296
[   80.621824] uvcvideo: Marking buffer as bad (error bit set).
[   80.621827] uvcvideo: Frame complete (FID bit toggled).
[   80.621834] uvcvideo: frame 2136 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2102820693/2102820694/32600
[   80.621837] uvcvideo: Marking buffer as bad (error bit set).
[   80.623785] uvcvideo: Marking buffer as bad (error bit set).
[   80.626895] uvcvideo: Marking buffer as bad (error bit set).
[   80.628846] uvcvideo: Marking buffer as bad (error bit set).
[   80.630705] uvcvideo: Marking buffer as bad (error bit set).
[   80.632698] uvcvideo: frame 2137 stats: 0/0/6 packets, 5/5/6 pts (!early initial), 5/6 scr, last pts/stc/sof 2102558546/2102558546/32594
[   80.632706] uvcvideo: Marking buffer as bad (error bit set).
[   80.632709] uvcvideo: Frame complete (FID bit toggled).
[   80.632715] uvcvideo: frame 2138 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2119336019/2102558802/32850
[   80.632718] uvcvideo: Marking buffer as bad (error bit set).
[   80.633058] uvcvideo: Frame complete (EOF found).
[   80.633403] uvcvideo: frame 2139 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2119336019/2102558802/32850
[   80.633412] uvcvideo: Marking buffer as bad (error bit set).
[   80.635832] uvcvideo: Marking buffer as bad (error bit set).
[   80.637813] uvcvideo: Marking buffer as bad (error bit set).
[   80.638509] uvcvideo: frame 2140 stats: 0/0/3 packets, 2/2/3 pts (!early initial), 2/3 scr, last pts/stc/sof 2102493009/2102493009/32593
[   80.638523] uvcvideo: Marking buffer as bad (error bit set).
[   80.638527] uvcvideo: Frame complete (FID bit toggled).
[   80.638537] uvcvideo: frame 2141 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2117435445/2100723765/32824
[   80.638541] uvcvideo: Marking buffer as bad (error bit set).
[   80.638817] uvcvideo: Frame complete (EOF found).
[   80.641019] uvcvideo: Marking buffer as bad (error bit set).
[   80.641028] uvcvideo: Dropping payload (out of sync).
[   80.641709] uvcvideo: frame 2142 stats: 0/0/2 packets, 1/1/2 pts (!early initial), 1/2 scr, last pts/stc/sof 2102362191/2102493265/32847
[   80.641719] uvcvideo: Marking buffer as bad (error bit set).
[   80.644143] uvcvideo: Marking buffer as bad (error bit set).
[   80.646129] uvcvideo: Marking buffer as bad (error bit set).
[   80.646798] uvcvideo: Marking buffer as bad (error bit set).
[   80.649234] uvcvideo: frame 2143 stats: 0/0/4 packets, 3/3/4 pts (!early initial), 3/4 scr, last pts/stc/sof 2101903432/2102034506/32844
[   80.649243] uvcvideo: Marking buffer as bad (error bit set).
[   80.649247] uvcvideo: Frame complete (FID bit toggled).
[   80.649254] uvcvideo: frame 2144 stats: 0/0/1 packets, 0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof 2085060423/2084994887/32582
[   80.649256] uvcvideo: Marking buffer as bad (error bit set).



[...]

Best Regards,

Mark
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

