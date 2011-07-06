Return-path: <mchehab@localhost>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1961 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1GFJpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 05:45:50 -0400
Message-ID: <4a089008008b14191f6174d31c7e1750.squirrel@webmail.xs4all.nl>
In-Reply-To: <1309944280-11936-1-git-send-email-t.stanislaws@samsung.com>
References: <1309944280-11936-1-git-send-email-t.stanislaws@samsung.com>
Date: Wed, 6 Jul 2011 11:45:42 +0200
Subject: Re: [PATCH 2/2] v4l2-ctl: fix wrapped open/close
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Tomasz Stanislawski" <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	mchehab@redhat.com, pawel@osciak.com, hdegoede@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

> When running in libv4l2 warp mode, the application did not use
> v4l2_open and v4l2_close in some cases. This patch fixes this
> issue substituting open/close calls with test_open/test_close
> which are libv4l2-aware.

This is already fixed in the latest version. I found the same
bug recently.

Regards,

      Hans

>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl.cpp |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 227ce1a..02f97e4 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -1604,13 +1604,13 @@ static void list_devices()
>
>  	for (dev_vec::iterator iter = files.begin();
>  			iter != files.end(); ++iter) {
> -		int fd = open(iter->c_str(), O_RDWR);
> +		int fd = test_open(iter->c_str(), O_RDWR);
>  		std::string bus_info;
>
>  		if (fd < 0)
>  			continue;
>  		doioctl(fd, VIDIOC_QUERYCAP, &vcap);
> -		close(fd);
> +		test_close(fd);
>  		bus_info = (const char *)vcap.bus_info;
>  		if (cards[bus_info].empty())
>  			cards[bus_info] += std::string((char *)vcap.card) + " (" + bus_info +
> "):\n";
> @@ -2535,7 +2535,7 @@ int main(int argc, char **argv)
>  		return 1;
>  	}
>
> -	if ((fd = open(device, O_RDWR)) < 0) {
> +	if ((fd = test_open(device, O_RDWR)) < 0) {
>  		fprintf(stderr, "Failed to open %s: %s\n", device,
>  			strerror(errno));
>  		exit(1);
> @@ -3693,6 +3693,6 @@ int main(int argc, char **argv)
>  			perror("VIDIOC_QUERYCAP");
>  	}
>
> -	close(fd);
> +	test_close(fd);
>  	exit(app_result);
>  }
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


