Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2IJObc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 10:31:32 -0400
Message-ID: <504DF9AE.6020908@redhat.com>
Date: Mon, 10 Sep 2012 11:31:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 4/5] DocBook: update ioctl error codes
References: <1345076921-9773-1-git-send-email-crope@iki.fi> <1345076921-9773-5-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-5-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-08-2012 21:28, Antti Palosaari escreveu:
> ENOTTY is now returned for unimplemented ioctl by dvb-frontend.
> Old EOPNOTSUPP & ENOSYS could be still returned by some drivers
> as well as other "non standard" error codes.
> 
> EAGAIN is returned in case of device is in state where it cannot
> perform requested operation. This is for example sleep and statistics
> are queried. Quick check for few demodulator drivers reveals there is
> a lot of different error codes used in such case currently, few to
> mention still: EOPNOTSUPP, ENOSYS, EAGAIN ... Lets try harmonize.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/gen-errors.xml | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
> index 5bbf3ce..737ecaa 100644
> --- a/Documentation/DocBook/media/v4l/gen-errors.xml
> +++ b/Documentation/DocBook/media/v4l/gen-errors.xml
> @@ -7,6 +7,13 @@
>      <tbody valign="top">
>  	<!-- Keep it ordered alphabetically -->
>        <row>
> +	<entry>EAGAIN</entry>
> +	<entry>The ioctl can't be handled because the device is in state where
> +	       it can't perform it. This could happen for example in case where
> +	       device is sleeping and ioctl is performed to query statistics.

While the comments here actually depend on your new version of patch 3/5, 
returning -EAGAIN is a valid return code, already used (there are 155 
occurrences of it right now).

So, I'll apply it.


> +	</entry>
> +      </row>
> +      <row>
>  	<entry>EBADF</entry>
>  	<entry>The file descriptor is not a valid.</entry>
>        </row>
> @@ -51,11 +58,6 @@
>  	       for periodic transfers (up to 80% of the USB bandwidth).</entry>
>        </row>
>        <row>
> -	<entry>ENOSYS or EOPNOTSUPP</entry>
> -	<entry>Function not available for this device (dvb API only. Will likely
> -	       be replaced anytime soon by ENOTTY).</entry>
> -      </row>
> -      <row>
>  	<entry>EPERM</entry>
>  	<entry>Permission denied. Can be returned if the device needs write
>  		permission, or some special capabilities is needed
> 

Regards,
Mauro
