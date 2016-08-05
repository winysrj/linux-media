Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:37718 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbcHEJ6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 05:58:20 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Sphinx-doc: build over N processes in parallel
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160720110413.68334513@recife.lan>
Date: Fri, 5 Aug 2016 11:56:44 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <800F814C-6238-4AF3-8D35-81EBD6EDEDFA@darmarit.de>
References: <d612024e7d2acd7ec82c75b5fed271fd61673386.1469017917.git.mchehab@s-opensource.com> <20160720100027.440796a4@recife.lan> <250A8BC9-A965-4162-BF63-6FFFBCD42D89@darmarit.de> <20160720110413.68334513@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 16:04 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> 
> A completely unrelated question: it seems that Sphinx is using just
> one CPU to do its builds:
> 
> %Cpu0  :  3,0 us,  7,6 sy,  0,0 ni, 89,4 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
> %Cpu1  :100,0 us,  0,0 sy,  0,0 ni,  0,0 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
> %Cpu2  :  1,3 us,  2,7 sy,  0,0 ni, 95,7 id,  0,3 wa,  0,0 hi,  0,0 si,  0,0 st
> %Cpu3  :  1,0 us,  3,3 sy,  0,0 ni, 95,7 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
> KiB Mem : 15861876 total,  5809820 free,  1750528 used,  8301528 buff/cache
> KiB Swap:  8200188 total,  8200188 free,        0 used. 13382964 avail Mem 
> 
>  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND     
> 5660 mchehab   20   0  325256  89776   8300 R  99,7  0,6   0:22.25 sphinx-bui+ 
> 
> Are there any way to speed it up and make it use all available CPUs?

Hi Mauro, 

sorry for the late reply. There is a sphinx-build option "-j N" [1].
It is in a *experimental* state in Sphinx v1.2 and has been improved 
in v1.3. Set e.g. "-j2" to the SPHINXOPTS to use two cores.

 make SPHINXOPTS=-j2 htmldocs

But take into account what the documentation says: """not all parts and 
not all builders of Sphinx can be parallelized.""".

[1] http://www.sphinx-doc.org/en/stable/invocation.html#cmdoption-sphinx-build-j

-- Markus 