Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:56490 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbZCJKJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 06:09:01 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2512250wfa.4
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 03:08:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49B62DDA.4060307@maxwell.research.nokia.com>
References: <A24693684029E5489D1D202277BE89442E40F5B2@dlee02.ent.ti.com>
	 <49B62DDA.4060307@maxwell.research.nokia.com>
Date: Tue, 10 Mar 2009 19:08:59 +0900
Message-ID: <5e9665e10903100308k7270db67w7947ee4b85eac120@mail.gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update)
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I'm also having problem pulling your git now. I've pulled prior
version of yours and this is second time of pulling your repository.

Here you are a part of git diff message of mine after pulling your
TUESDAY MARCH 10 version. Looks like all about indent thing.

What should I do? If I want to pull your repository in my repository
and merging automatically.

I don't have any clue ;-(

kdsoo@chromatix:/home/share/GIT/OMAP3430/linux-2.6.29-rc3-omap_sakari$ git diff

diff --cc drivers/media/video/isp/isp.c

index 12a545c,54c839b..0000000

--- a/drivers/media/video/isp/isp.c

+++ b/drivers/media/video/isp/isp.c

@@@ -47,7 -47,7 +47,11 @@@

  static struct isp_device *omap3isp;



  static int isp_try_size(struct v4l2_pix_format *pix_input,

++<<<<<<< .merge_file_S5fkv9

 +                                      struct v4l2_pix_format *pix_output);

++=======

+                       struct v4l2_pix_format *pix_output);

++>>>>>>> .merge_file_ygq1qZ



On Tue, Mar 10, 2009 at 6:07 PM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> Aguirre Rodriguez, Sergio Alberto wrote:
>>
>> Hi Sakari,
>
> Hello, Sergio!
>
>> Doing a pull like you suggested in past release:
>>  $ git pull http://git.gitorious.org/omap3camera/mainline.git v4l \
>>   iommu omap3camera base
>>
>> Brings the same code than before...
>
> Oops. Could you try again now?
>
>> I see that omap3isp branch is updated on gitorious, but trying to pull
>> that branch gives merge errors.
>
> Are you pulling it on top of linux-omap?
>
> I've replaced the whole patchset so git tries to apply the new patches on
> top of the old ones.
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
