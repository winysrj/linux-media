Return-path: <video4linux-list-bounces@redhat.com>
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 26 Mar 2009 10:36:56 -0300
References: <200903231708.08860.lamarque@gmail.com>
	<200903251117.07201.lamarque@gmail.com>
	<49CB4D4E.6030901@redhat.com>
In-Reply-To: <49CB4D4E.6030901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261036.57317.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4
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

Em Thursday 26 March 2009, Hans de Goede escreveu:
> Hi all,
>
> Not quite, the correct behaviour is:
> "If the field value is set to an unsupported value, then set the field
> value to *a* value that the driver accepts"

	Now I get it. This webcam only accepts V4L2_FIELD_NONE, so commenting that 
part of try_fmt makes it compliant with v4l2 standard. Thank you for helping 
me with this. The zr364xx's maintainer contacted me yesterday, he is busy 
theses days, when he has more time he is going to take a look at my changes. 
With lucky the changes will be in 2.6.30. At least 2.6.29 sets the 
compat_ioctl32 automatically for all drivers, in 2.6.28.8 I had to set it in 
the driver to make Skype and mplayer (32-bit) work, one less change for the 
driver :-)

> This takes in to account certain devices can support multiple field types,
> which is the whole purpose of the field value.
>
> And yes unfortunately many many v4l drivers have various bugs in their
> implementation, in some cases I do work around driver bugs in libv4l, but
> it this case that would hurt proper use of the field value, and that is not
> acceptable, so fixing the driver is the only solution.

	Have you tried to contact the drivers' maintainers for fixing those bugs?

> Note, that the v4l2 API is pretty well documented, and the correct
> behaviour as I describe it can be found in the docs too:
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/r10944.htm
>
> And the "Return Value" section, note how EINVAL is only supposed to be
> returned up on an invalid, or unsupported type value. And also from the
> description: "Drivers should not return an error code unless the input is
> ambiguous"


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
