Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48017 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbcIBOyh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 10:54:37 -0400
Date: Fri, 2 Sep 2016 11:54:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst:sphinx-extensions: add metadata parallel-safe
Message-ID: <20160902115428.2acf1e8a@vento.lan>
In-Reply-To: <99F693FF-B49B-43DE-9D03-632121FCAE0A@darmarit.de>
References: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de>
        <20160901082136.597c37bf@lwn.net>
        <87inufzoa5.fsf@intel.com>
        <99F693FF-B49B-43DE-9D03-632121FCAE0A@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 1 Sep 2016 18:22:09 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 01.09.2016 um 16:29 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
> 
> > On Thu, 01 Sep 2016, Jonathan Corbet <corbet@lwn.net> wrote:  
> >> On Wed, 24 Aug 2016 15:35:24 +0200
> >> Markus Heiser <markus.heiser@darmarit.de> wrote:
> >>   
> >>> With metadata "parallel_read_safe = True" a extension is marked as
> >>> save for "parallel reading of source". This is needed if you want
> >>> build in parallel with N processes. E.g.:
> >>> 
> >>>  make SPHINXOPTS=-j4 htmldocs  
> >> 
> >> A definite improvement; applied to the docs tree, thanks.  
> > 
> > The Sphinx docs say -jN "should be considered experimental" [1]. Any
> > idea *how* experimental that is, really? Could we add some -j by
> > default?  
> 
> My experience is, that parallel build is only strong on "reading
> input" and weak on "writing output". I can't see any rich performance
> increase on more than -j2 ... 
> 
> Mauro posted [2] his experience with -j8 compared to serial. He
> also compares -j8 to -j16:
> 
> > PS: on my server with 16 dual-thread Xeon CPU, the gain with a
> > bigger value for -j was not impressive. Got about the same time as
> > with -j8 or -j32 there.  
> 
> I guess he will get nearly the same results with -j2 ;)
> 
> If we want to add a -j default, I suggest -j2. 

Actually, here I got better results with -j4, on my NUC with
one quad-core, 8 threads Intel(R) Core(TM) i7-6770HQ CPU @ 2.60GHz
and m2SATA SSD disk. 

This is with -j2:

$ make DOCBOOKS="" SPHINXOPTS="-j2" SPHINXDIRS=media SPHINX_CONF="conf_nitpick.py" htmldocs 2>err

real	0m46.568s
user	1m0.676s
sys	0m3.019s

And this is with -j4:

$ make DOCBOOKS="" SPHINXOPTS="-j4" SPHINXDIRS=media SPHINX_CONF="conf_nitpick.py" htmldocs 2>err

real	0m25.356s
user	1m1.408s
sys	0m2.912s

Btw, this is the result on a dual octa-core Intel(R) Xeon(R) CPU E5-2670 0 
@ 2.60GHz, CPU (total of 32 threads), using PCIe SSD disks:

$ for i in $(seq 32 -1 1); do echo "with SPHINXOPTS= -j$i"; make cleandocs;/usr/bin/time --format="real %E nuser %U sys %S" make DOCBOOKS=""  SPHINXOPTS="-j$i" SPHINXDIRS=media SPHINX_CONF="conf.py" SPHINXDIRS=media htmldocs >err; done
with SPHINXOPTS= -j32
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.05 nuser 98.77 sys 6.45
with SPHINXOPTS= -j31
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:22.81 nuser 97.80 sys 6.12
with SPHINXOPTS= -j30
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.16 nuser 97.68 sys 6.41
with SPHINXOPTS= -j29
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:22.74 nuser 98.02 sys 6.33
with SPHINXOPTS= -j28
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.18 nuser 95.75 sys 6.14
with SPHINXOPTS= -j27
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:22.67 nuser 96.66 sys 6.27
with SPHINXOPTS= -j26
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:22.66 nuser 95.93 sys 6.50
with SPHINXOPTS= -j25
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.71 nuser 95.43 sys 6.43
with SPHINXOPTS= -j24
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.71 nuser 94.27 sys 6.42
with SPHINXOPTS= -j23
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.46 nuser 93.85 sys 6.35
with SPHINXOPTS= -j22
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.28 nuser 91.52 sys 6.29
with SPHINXOPTS= -j21
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.93 nuser 90.37 sys 6.14
with SPHINXOPTS= -j20
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:24.88 nuser 91.40 sys 6.36
with SPHINXOPTS= -j19
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:24.00 nuser 89.68 sys 5.82
with SPHINXOPTS= -j18
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.73 nuser 89.68 sys 5.92
with SPHINXOPTS= -j17
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.75 nuser 87.85 sys 5.58
with SPHINXOPTS= -j16
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:24.54 nuser 87.87 sys 5.94
with SPHINXOPTS= -j15
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:25.45 nuser 88.25 sys 6.28
with SPHINXOPTS= -j14
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.79 nuser 87.23 sys 5.80
with SPHINXOPTS= -j13
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:24.15 nuser 86.06 sys 5.48
with SPHINXOPTS= -j12
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:24.02 nuser 85.94 sys 5.55
with SPHINXOPTS= -j11
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:23.79 nuser 85.12 sys 5.38
with SPHINXOPTS= -j10
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:25.37 nuser 85.32 sys 5.52
with SPHINXOPTS= -j9
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:26.04 nuser 86.96 sys 5.58
with SPHINXOPTS= -j8
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:26.76 nuser 86.38 sys 5.84
with SPHINXOPTS= -j7
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:27.90 nuser 85.33 sys 5.54
with SPHINXOPTS= -j6
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:28.44 nuser 84.59 sys 5.44
with SPHINXOPTS= -j5
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:31.82 nuser 83.98 sys 5.56
with SPHINXOPTS= -j4
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:35.68 nuser 83.98 sys 5.52
with SPHINXOPTS= -j3
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 0:43.00 nuser 85.08 sys 5.78
with SPHINXOPTS= -j2
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 1:10.72 nuser 88.61 sys 6.17
with SPHINXOPTS= -j1
make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
real 1:27.23 nuser 84.49 sys 2.97

There, -j4 is not the best performance. it goes to the ~23-24 seconds only
with -j11.

So, setting a default is not trivial, and seems to depend a lot on the
actual machine used on the build.

Regards,
Mauro
