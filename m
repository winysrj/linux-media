Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG1niTR024013
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 20:49:44 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBG1nVsL026516
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 20:49:31 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2676473wfc.6
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 17:49:31 -0800 (PST)
Message-ID: <aec7e5c30812151749y601970a6meecbd4393977ccf0@mail.gmail.com>
Date: Tue, 16 Dec 2008 10:49:30 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uskopgdav.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
	<aec7e5c30812150328t70117d7fp8eee31de4ac223ae@mail.gmail.com>
	<uskopgdav.wl%morimoto.kuninori@renesas.com>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH re-send v2] Add interlace support to
	sh_mobile_ceu_camera.c
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

On Tue, Dec 16, 2008 at 9:43 AM,  <morimoto.kuninori@renesas.com> wrote:
> How about this ?
>
> static void sh_mobile_ceu_capture( xxxx )
> {
>        dma_addr_t phys_addr_top;
> =>      dma_addr_t phys_addr_bottom = icd->width;
>        ....
>
>        phys_addr_top = videobuf_to_dma_contig(pcdev->active);
>        ceu_write(pcdev, CDAYR, phys_addr_top);
>        if (pcdev->is_interlace) {
> =>              phys_addr_bottom += phys_addr_top;
>                ceu_write(pcdev, CDBYR, phys_addr_bottom);
>        }

Let me try to explain in more detail. Today your patch is using the
bottom variable in three places:

1. declaration and initialization:
{
  phys_addr_t phys_addr_t;
  phys_addr_t phys_addr_b = 0;

2. for y plane:
  phys_addr_t = videobuf_to_dma_contig();
  ceu_write(phys_addr_t);
  if (interlace) {
    phys_addr_b = phys_addr_t + icd->width;
    ceu_write(phys_addr_b);
  }

3. for uv plane
  case YUV_MODE:
    phys_addr_t += (icd->width * icd->height);
    ceu_write(phys_addr_t);
    if (interlace) {
      phys_addr_b += (icd->width * icd->height);
      ceu_write(phys_addr_b);
    }

Part 3 will generate warning if you remove part 1, right?

I recommend you to do the following instead:

1. declaration and initialization:
{
  phys_addr_t phys_addr_top;
  phys_addr_t phys_addr_bottom; /* no setup needed */

2. for y plane: (same logic as before)
  phys_addr_top = videobuf_to_dma_contig();
  ceu_write(phys_addr_top);
  if (interlace) {
    phys_addr_bottom = phys_addr_top + icd->width; /* no parenthesis needed */
    ceu_write(phys_addr_bottom);
  }

3. for uv plane
  case YUV_MODE:
    phys_addr_top += icd->width * icd->height; /* no parenthesis needed */
    ceu_write(phys_addr_top);
    if (interlace) {
      phys_addr_bottom = phys_addr_top + icd->width; /* look, "="
instead of "+= */
      ceu_write(phys_addr_bottom);
    }

My version of part 3 should generate the same value for
phys_addr_bottom, but this without the need for the initialization
code in part 1. I may be wrong though, maybe the phys_addr_bottom
value calculation is incorrect in my case?

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
