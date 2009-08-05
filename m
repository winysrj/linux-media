Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n75Aclxp031863
	for <video4linux-list@redhat.com>; Wed, 5 Aug 2009 06:38:47 -0400
Received: from mail-qy0-f201.google.com (mail-qy0-f201.google.com
	[209.85.221.201])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n75AcXWu010405
	for <video4linux-list@redhat.com>; Wed, 5 Aug 2009 06:38:34 -0400
Received: by qyk39 with SMTP id 39so5551898qyk.23
	for <video4linux-list@redhat.com>; Wed, 05 Aug 2009 03:38:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ubpmumuhg.wl%morimoto.kuninori@renesas.com>
References: <ubpmumuhg.wl%morimoto.kuninori@renesas.com>
Date: Wed, 5 Aug 2009 19:38:32 +0900
Message-ID: <aec7e5c30908050338l2ae7bed2q6b2b35d0ff9084f7@mail.gmail.com>
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2] sh_mobile_ceu: add soft reset function
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

On Wed, Aug 5, 2009 at 7:21 PM, Kuninori
Morimoto<morimoto.kuninori@renesas.com> wrote:
> +       while (t--) {
> +               if (!(ceu_read(pcdev, CAPSR) & (1 << 16)))
> +                       break;
> +               cpu_relax();
> +       }
> +
> +       t = 10000;
> +       while (t--) {
> +               if (!(ceu_read(pcdev, CSTSR) & 1))
> +                       break;
> +               cpu_relax();
> +       }
> +}
> +
>  /*
>  *  Videobuf operations
>  */
> @@ -366,9 +386,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
>
>        clk_enable(pcdev->clk);
>
> -       ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
> -       while (ceu_read(pcdev, CSTSR) & 1)
> -               msleep(1);

So the original code is using msleep(1) for timing, but your new code
does not have any delay in the loops. Please use some delay code in
there so that the polling times out after a known amount of time. In
this version the time depends on cpu speed which is not so good.

Thanks,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
