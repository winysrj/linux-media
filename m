Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OLBEgq019832
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 17:11:14 -0400
Received: from mail-qy0-f104.google.com (mail-qy0-f104.google.com
	[209.85.221.104])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2OLAsXw010303
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 17:10:54 -0400
Received: by qyk2 with SMTP id 2so3423872qyk.23
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 14:10:53 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: "Theodoros V. Kalamatianos" <thkala@softlab.ece.ntua.gr>
Date: Tue, 24 Mar 2009 18:10:44 -0300
References: <200903231708.08860.lamarque@gmail.com>
	<200903241605.07230.lamarque@gmail.com>
	<alpine.LMD.1.10.0903242247470.17631@infinity.deepcore.ngn>
In-Reply-To: <alpine.LMD.1.10.0903242247470.17631@infinity.deepcore.ngn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241810.44995.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4l
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

Em Tuesday 24 March 2009, Theodoros V. Kalamatianos escreveu:
> On Tue, 24 Mar 2009, Lamarque Vieira Souza wrote:
> >>> LD_PRELOAD=/usr/lib32/libv4l2.so /opt/skype/skype
> >>>
> >>>        /opt/skype/skype is the binary executable. There is not error
> >>> message about LD_PRELOAD or libv4l. Skype returns:
> >>>
> >>> Skype V4L2: Could not find a suitable capture format
> >>> Skype V4L2: Could not find a suitable capture format
> >>> Starting the process...
> >>> Skype Xv: Xv ports available: 4
> >>> Skype XShm: XShm support enabled
> >>> Skype Xv: Using Xv port 131
> >>> Skype Xv: No suitable overlay format found
>
> Keep in mind that LD_PRELOAD will be silently ignored for static binaries
> and it will simply NOT WORK. Are you certain that you are not using the
> static version of Skype?

	I am using the static version of Skype, but Skype is statically linked 
against Qt4 only, it is dynamically linked against all other libraries. Now I 
can get log using LIBV4L2_LOG_FILENAME if I preload this way:

LD_PRELOAD=/usr/lib32/libv4l/v4l2convert.so /opt/skype/skype

	I have found the problem. The vidioc_try_fmt_vid_cap function in the driver 
return -EINVAL if the fmt.pix.field is different from V4L2_FIELD_ANY or 
V4L2_FIELD_NONE. Skype seems to set this field as V4L2_FIELD_INTERLACED. 
Because of that libv4l assumes that all destination formats (YUV420 included) 
are invalid. Commenting this part of the driver makes Skype work and it is 
showing pictures. YES!!! :-)

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
