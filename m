Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF9NU8q012431
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 04:23:30 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBF9NGaI031997
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 04:23:17 -0500
Received: by rv-out-0506.google.com with SMTP id f6so2713698rvb.51
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 01:23:16 -0800 (PST)
Message-ID: <aec7e5c30812150123i25ecf9dx139c45a7534e2c16@mail.gmail.com>
Date: Mon, 15 Dec 2008 18:23:16 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812151000280.4416@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <utz9bmtgn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812132131410.10954@axis700.grange>
	<umyeyuivo.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812150844560.3722@axis700.grange>
	<aec7e5c30812150028t11589040g3ae33eb2c82bbf08@mail.gmail.com>
	<Pine.LNX.4.64.0812150932320.3722@axis700.grange>
	<aec7e5c30812150055y4bd8b1f4rb969be546456fb93@mail.gmail.com>
	<Pine.LNX.4.64.0812151000280.4416@axis700.grange>
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add tw9910 driver
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

On Mon, Dec 15, 2008 at 6:11 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 15 Dec 2008, Magnus Damm wrote:
>> On Mon, Dec 15, 2008 at 5:33 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Good, then passing it directly to the camera driver should be enough for
>> > now.
>>
>> Yeah. I guess this all means that we have to rework things a bit. So
>> the interlace patch needs to be updated. Which affects my cleanup
>> patch. Do you have any preference on how to proceed? I'd go with just
>> keep on adding things - this means my cleanup patch that i'm about to
>> send will still apply - but I'm fine rewriting and reposting as well.
>
> As you see, patches
>
> [PATCH 02/03] sh_mobile_ceu: add NV12 and NV21 support
> [PATCH] Add interlace support to sh_mobile_ceu_camera.c
> [PATCH] Add tw9910 driver
>
> need modifications, so, I would prefer to have them re-done instead of
> incrementally fixing them. This doesn't include of course parenthesis and
> ceu_write / ceu_read typing fixes to existing code - this should be a
> separate patch.

Hm, I thought you only needed a NV12 patch consisting of more or less
cosmetic changes? I guess the dma_addr_t change may be in a gray zone
though. I'd prefer not to touch the NV12 and NV16 patches except for a
cleanup patch if possible, but I will of course update and resend the
NV12 patch if you prefer that.

> BTW, you realise, that I'm not handling this your patch:
>
> [PATCH] videobuf-dma-contig: fix USERPTR free handling
>
> Have you got an ack for it yet?

No, I haven't. Not so strange though since that the CEU driver is the
only user. =) And most programs simply do mmap() so I don't think
Morimoto-san is running into this issue. But getting it included would
be great. Also the NV16 fourcc definitions would be nice to have
included.

Thanks.

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
