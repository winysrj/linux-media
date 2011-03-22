Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63706 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1CVMLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103211421040.24139@axis700.grange>
References: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
	<Pine.LNX.4.64.1102221057040.1380@axis700.grange>
	<AANLkTikA0QDCLNSrM3FGobEzBBh9hcP_ZpyC+4YPSbx7@mail.gmail.com>
	<Pine.LNX.4.64.1103211421040.24139@axis700.grange>
Date: Tue, 22 Mar 2011 21:11:01 +0900
Message-ID: <AANLkTi=q_Spa9hWDDKZJ0UBnYtLBZTS+tkFx1J5B_3gk@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: switch mackerel to dynamically manage the
 platform camera
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Mar 21, 2011 at 10:22 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 16 Mar 2011, Magnus Damm wrote:
>
>> On Tue, Feb 22, 2011 at 6:57 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Use soc_camera_platform helper functions to dynamically manage the
>> > camera device.
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > ---
>> >  arch/arm/mach-shmobile/board-mackerel.c |   28 +++++++---------------------
>> >  1 files changed, 7 insertions(+), 21 deletions(-)
>>
>> I just tested patch 1/3 and patch 3/3 on my Mackerel board.
>
> Thanks for testing!
>
>> Unfortunately I get this printout on the console:
>>
>> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
>> soc_camera_platform soc_camera_platform.0: Platform has not set
>> soc_camera_device pointer!
>> soc_camera_platform: probe of soc_camera_platform.0 failed with error -22
>> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0
>>
>> Without these two patches everything work just fine. Any ideas on how
>> to fix it? I'd be happy to test V2. =)
>
> Hm, yes, looks like I'm initialising the pointer too late. Could you,
> please, test the patch below on top, if it helps, I'll send v2.

Yes, this incremental change solves the problem. Thanks!

Please post V2 and add:

Acked-by: Magnus Damm <damm@opensource.se>
