Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:39142 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZD2VgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 17:36:04 -0400
Date: Wed, 29 Apr 2009 16:49:43 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Robin van Kleeff <robinvankleeff@gmail.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Digital compact cameras that can be used as video devices?
In-Reply-To: <a50ea2b0904291222p34e897e1qc2fb0f4ade337e6@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0904291443001.20733@banach.math.auburn.edu>
References: <a50ea2b0904291222p34e897e1qc2fb0f4ade337e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I will try to answer some of the questions to the best of my ability:

First, as I think I mentioned, responding to your similar query on the 
gphoto-users list, there is a division of labor in Linux between still 
camera support and support for streaming. The reason for this is that 
still camera support can be done 100% in userspace, whereas streaming can 
not. So what you will typically find is that if device X is a dual-mode 
device which is fully supported, then it will be supported by Gphoto as a 
still camera, with accompanying information about that over there, and by 
the video4linux project as a streaming device, with any information about 
that found over here.

The rest of my response, you will find "in line" below.


On Wed, 29 Apr 2009, Robin van Kleeff wrote:

> Hey everybody,
>
> I have been searching for information on using compact photo cameras
> as video devices (and also for compatibility with gphoto through the
> gphoto websites/mailing list).
>
> I was wondering if any of you knows which cameras (brand, type) I
> should focus on?

I can only mention the cameras that I personally have supported. I do not 
know very much about any others. The cameras that I have supported usually 
run toward being cheap. As to the rest of them, I think that you will find 
practically all of the current support for dual-mode cameras to do 
streaming is in the gspca project. The most current support of all is, of 
course, in the most current code. That code may not be in your current 
kernel version, but by intention you ought to be able to download it and 
look at it and compile it and install it. What will happen if you do these 
steps is, the modules in drivers/media/video will be compiled for the 
kernel which is detected on your installation, and the currently existing 
modules in drivers/media/video will be overwritten. Within reasonable 
limitations, the code is supposed to work with recent kernel releases.

So, my first proposal to you would be to download the most current version 
of the code. Since Jean-Francois Moine is the maintainer of the most 
current gspca code, which is probably what would interest you, I would 
suggest to do

hg clone http://linuxtv.org/hg/~jfrancois/gspca/

and to take a look at the subdirectory

linux/drivers/media/video/gspca

and/or the directory

linux/Documentation/video4linux/gspca.txt

and see if you find anything there of interest. I think I mentioned 
already, in response to your post on the gphoto-users list, that the 
cameras supported by the drivers libgphoto2/camlibs/sq905 and 
camlibs/digigr8 and some of the cameras supported by camlibs/mars can also 
perform now in streaming mode. However, my impression was that you are 
looking for a better camera than one of these. I do not blame you for 
that; those things are all cheap cameras even though some of them take 
fairly decent photos, with resolutions up to 640x480. There may be some 
other cameras that you will recognize, though, because gspca does support 
lots of cameras. Also do not neglect to look for cameras which are not in 
gspca but will also be listed in the source code I suggested to you to 
download. Some of the other things supported in linux/drivers/media/video 
are cameras, too. And some of those may be still cameras as well as video 
cameras. So if you recognize such a thing, then, good.

Also, a remark or two about how to recognize a camera:

There is, of course, the documentation in linux/Documentation/video4linux 
which might help. However, that documentation is often sketchy. The 
problem is, there are lots of mass-produced chips out there for running 
cameras, and there are lots of brand names and "models" where the 
mass-produced chip has been slapped into a case and a decal or 
paintbrush has been used on the plastic exterior, claiming that this is 
model X from manufacturer Y. The same chip might be inside 40 different 
so-called models from various manufacturers. Even worse, if the 
manufacturer feels like buying some other chips, in job lots, and putting 
them into the next batch of the same make and model, then said 
manufacturer might just go right ahead and do that. So the only way to 
know what is really supposed to be there is to look at the two four-digit 
hexadecimal numbers consisting of the vendor number and the product 
number. If you want to see some samples of this in action, then go to the 
website qbik.ch and browse the lists there. That website, incidentally, is 
supposed to give information about various USB hardware and the status of 
its Linux support. It is always out of date, of course. One of the reasons 
for that is, developers who supported a chip which runs in 40 cameras do 
not want to bother to go there and put in an entry for every single one of 
them. Another reason is (and I have had that experience several times!) 
that I personally have supported some device and know it works, and the 
code is out there in some project. But before I got to qbik.ch someone 
else has already been there and informed us all that the device does not 
work and is unsupported. And then after doing the support myself I can not 
change the other guy's entry. If he disappeared, then the entry will never 
get changed.


> I'm interested in digital compact camera that can be
> used to take decent quality pictures, and also function as for
> instance a web cam for applications such as Ekiga.  I am unable to
> find any lists of cameras that are supported.

Sorry, I do not know anything at all about Ekiga.

>
> By the way, I am much more an end-user then a developer, so forgive me
> if I ask dumb questions, or if I ask questions that are outside of the
> scope of this mailing list.

If there is no other list dealing with this kind of inquiry, then clearly 
the questions are not outside of the scope of the mailing list.

>
> Thanks in advance!
>
> Robin
> --

Hoping that this helps some, and hoping that some others can fill in 
the blanks that I left.

Theodore Kilgore
