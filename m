Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:61485 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab3FUHOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:14:16 -0400
MIME-Version: 1.0
In-Reply-To: <51C3865A.4050701@gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-4-git-send-email-arun.kk@samsung.com>
	<51C3865A.4050701@gmail.com>
Date: Fri, 21 Jun 2013 12:44:14 +0530
Message-ID: <CALt3h7_r3QLQs1urkhQO+1fCv1J+RaWSQ511RJELxE91cgEUdA@mail.gmail.com>
Subject: Re: [RFC v2 03/10] exynos5-fimc-is: Adds common driver header files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Jun 21, 2013 at 4:16 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Guys, I was wondering how difficult would be to make a common driver
> for the Exynos4 and Exynos5 FIMC-IS ? My feeling is that it would allow
> to save significant amount of code, since the hardware has many
> similarities. I imagine it would be a lot of work, and testing would have
> been a bit difficult. But would it really to troublesome to make a common
> driver ? Could you list some arguments against it ? For the MFC we have
> same driver, handling different firmware versions. Similarly for the other
> media IPs. Only the FIMC-IS subsystems would have separate drivers.
> My intentions is really only to reduce the amount of code we would have
> to merge with this new driver, nothing else. But I'm not going to push
> for the common driver if this is too much trouble.

We have thought about it while starting the development and major
arguments against common driver are :

- FIMC-IS IP has significantly changed from Exynos4.
In Exynos4, it has sub-components ISP, DRC and FD where as in exynos5,
it has ISP, DRC, SCC, ODC, DIS. 3DNR, SCP and FD.

- The FW design has changed considerably to make use of camera2 api
interface. Most of the code in the new driver is for this FW interface
which are done in fimc_is_pipeline.* and fimc_is_interface.*. This is the
major reason against a common driver as the new FW expects each
input frame to be passed along with the controls in a SHOT command.
It is a request-response mode handled per-frame by the FW which is
a major design philosophy change from exynos4.

- Two scalers introduced in the pipeline capable of DMA out which
again changes the pipeline design considerably compared to exynos4.

- The only common part of code between exynos 4 and 5 now is in
the fimc-isp.c and fimc-is-sensor.c and some control structures
in header files. If re-used, only some user controls part can be
re-used and most of the code will still be different.
>From the exynos5 driver, still the fimc-is-scaler.*, fimc-is-pipeline.*,
fimc-is-interface.* has to be retained which constitutes majority of the LOC.

Regards
Arun
