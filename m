Return-path: <mchehab@gaivota>
Received: from mail.kapsi.fi ([217.30.184.167]:56031 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1ELWl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 18:41:27 -0400
Message-ID: <4DCC59F5.6060306@iki.fi>
Date: Fri, 13 May 2011 01:06:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
Subject: Re: [PATCH 0/6] DVB-T2 API updates, documentation and accompanying
 small fixes
References: <4DC417DA.5030107@redhat.com> <1304869873-9974-1-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304869873-9974-1-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello all,

Rémi informed he have added this new API and DVB-T2 support for VLC 
media player Git tree [1]. I didn't test it yet, mostly due to lack of 
time :i I will test that sooner or later, feel free to test!

[1] http://git.videolan.org/?p=vlc.git


regards
Antti



On 05/08/2011 06:51 PM, Steve Kerrison wrote:
> Hi Mauro, Antti, Andreas,
>
> I hope this patch set is formed appropriately - it is my first patch
> submission direct to the linux-media group.
>
> Following the pull of Antti's work on support for the cxd2820r and PCTV
> nanoStick T2 290e, this patch set implements Andreas' modifications to the API
> to give provisional DVB-T2 support and the removal of a workaround for this
> in the cxd2820r module.
>
> In addition, there are some minor fixes to compiler warnings as a result
> of the expanded enums. I cannot test these myself but they treat unrecognized
> values as *_AUTO and I can't see where a problem would be created.
>
> I have updated the documentation a little. If I've done the right thing then
> I guess there is incentive there for me continue to expand DVB related
> elements of the API docs.
>
> This patch set has been tested by me on two systems, with one running a MythTV
> backend utilising a long-supported DVB tuner. MythTV works fine with the old
> tuner and the nanoStick T2 290e works in VLC. I've yet to test the 290e in
> MythTV - I was more intent on making sure the patches hadn't broken userland
> or older devices.
>
> Feedback, testing  and discussion of where to go next is welcomed!
>
> Regards,
> Steve Kerrison.
>


-- 
http://palosaari.fi/
