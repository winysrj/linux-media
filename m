Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ACXeVx008845
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 08:33:40 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ACXUSP029621
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 08:33:30 -0400
Received: by rv-out-0506.google.com with SMTP id f6so4080733rvb.51
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 05:33:29 -0700 (PDT)
Message-ID: <d9def9db0807100533u4a765210k8cce4b5ce5bec703@mail.gmail.com>
Date: Thu, 10 Jul 2008 14:33:29 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <20080710132337.11ca4706@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710132337.11ca4706@hyperion.delvare>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] tvaudio: Stop I2C driver ID abuse
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

Hi Jean,

On Thu, Jul 10, 2008 at 1:23 PM, Jean Delvare <khali@linux-fr.org> wrote:
> The tvaudio driver is using "official" I2C device IDs for internal
> purpose. There must be some historical reason behind this but anyway,
> it shouldn't do that. As the stored values are never used, the easiest
> way to fix the problem is simply to remove them altogether.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> This patch was already sent on:
>  * 2008-05-07
>

how would you identify what chip driver is attached in the
attach_inform callback, using string compare to the name?
using the ID was more comfortable actually, but I understand your
point for removing it too.

thanks,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
