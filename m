Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBC93mHS014324
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 04:03:48 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBC93Zt0011620
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 04:03:35 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1112915wfc.6
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 01:03:35 -0800 (PST)
Message-ID: <aec7e5c30812120103g417fdbafu649f782e8347fa40@mail.gmail.com>
Date: Fri, 12 Dec 2008 18:03:35 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uzlj1vlg2.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
	<uzlj1vlg2.wl%morimoto.kuninori@renesas.com>
Cc: video4linux-list@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCH 00/03] video: nv1x/nvx1 support for the sh_mobile_ceu
	driver V2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Morimoto-san,

On Fri, Dec 12, 2008 at 5:37 PM,  <morimoto.kuninori@renesas.com> wrote:
>
> Hi Magnus, Guennadi
>
>> [PATCH 01/03] sh_mobile_ceu: use new pixel format translation code
>> [PATCH 02/03] sh_mobile_ceu: add NV12 and NV21 support
>
> It works well on my environment !!
> I can not test NV16/61
> Thanks
>
> Acked-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Thanks for testing. Regarding NV16 and NV61, there is very little
support in open source tools for these formats. I've heard a positive
NV16 status report from other people using an internal NV16-extended
version of the my old NV12 patch, so I'm fairly confident in my NV16
implementation. Especially since the only logic changes from NV12 are
12bpp->16bpp and the no-lineskip setting. =)

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
