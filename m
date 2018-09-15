Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38358 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbeIPA43 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 20:56:29 -0400
Date: Sat, 15 Sep 2018 16:36:20 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] media-ctl: rework and merge mc_nextgen_test features
Message-ID: <20180915163620.5ae732ba@coco.lan>
In-Reply-To: <b29b6c04-1089-c58d-3335-a31a87f856bc@xs4all.nl>
References: <b29b6c04-1089-c58d-3335-a31a87f856bc@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Sep 2018 10:31:07 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Laurent, Mauro,
> 
> We currently have two competing utilities for controlling media devices:
> media-ctl and mc_nextgen_test, each with features that the other doesn't
> have. That's obviously not good.

Hi Hans,

My goal with this e-mail is to give you some hints about what *I* think
it would be easier/better. It is your time, so, spend it the way you want, 
but I suspect that, if you consider my advises, you may have less
headaches with the new toolchain.

> 
> I would like to work on adding the missing pieces for the new G_TOPOLOGY
> API to media-ctl.

That could be a lot of work. When I started working on it, I tried to extend
media-ctl, but media-ctl's internal model (libmediactl) is so tightly coupled
to the old topology ioctls that it would require a lot of work for it to do,
in order to make it support both APIs. After spending two or three days
trying to do that, I realized that starting from scratch and provide backward
compatibility with legacy API would be a way easier. That's why I created
mc_nextgen_test. The first working code took just a single day to write
(about one third of the time I spent with libmediactl).

The topology parsing code at mc_nextgen_test is a way smaller, more efficient
and less subject to errors than the model at media-ctl. While designing
MC nextgen, from time to time I had to fix wrong premises at libmediactl that
caused it to not be able to recognize a valid topology using v1 ioctls,
with were causing even core dumps on it.

So, I suggest you to at least take a look at mc_nextgen_test code. 

I intended to implement the link set logic there after we add a v2 for the
links creation ioctl (that was on our original plans), but I got sidetracked
by other projects after the end of the year I took to work on MC nextgen
patchset. Also, frankly, I got frustrated by the obstacules we (still) have 
for reviewing the ALSA patchset (with was one of the reasons why I worked
on MC in 2015: I wanted to be able to properly handle complex pipelines
on hybrid hardware and glue the different APIs with MC).

> As part of that I would really like to turn media-ctl
> into C++ (like the other V4L2/CEC utilities) so I can use the v4l2-info.cpp
> and media-info.cpp helpers. This will ensure consistent naming conventions
> throughout our utilities, which I think is a good thing.

We'll still have pure C code there: IR and DVB are C. I don't have any plans
to switch them to C++, as I don't see any benefit. My preference is to have
libraries written in C, as it makes a way easier to integrate with everything
including C and C++ userspace code, although a C++ library with a C
interface could work.

> With C++ you can
> also use the standard STL maps, lists, vectors, etc. which are ideal for
> processing a media topology.

Frankly, I don't see much gain, at least for the core part (ioctl and basic
handling).  The model I used at mc_nextgen_test is very simple (and 
quick/small, with is a plus). If I had written in C++, it would likely be
worse, slower and a way bigger.

IMHO, the best strategy would be to keep the library code in C, even if
the userspace tool itself is written in C++, but that's just my personal
preference.

> One thing that I really dislike about the media-ctl syntax is the use of
> characters that require quotes ('->' being the main offender). I would like
> to add an alternative syntax that avoids this.
> 
> I'm thinking that ' to ' (note the spaces) is a good alternative to '->'.
> Question: does '->' already require spaces? Or is 'pad1->pad2' equivalent
> to 'pad1 -> pad2'? I haven't dug into the parsing code yet.

See my comment about that below.

> 
> I'm a bit confused by this syntax:
> 
>         entity          = entity-number | ( '"' entity-name '"' ) ;
> 
> Shouldn't this be:
> 
>         entity          = entity-number | entity-name ;
> 
> The first syntax suggests that all entity-names must be written as "name",
> and that can't be right. Just checking if the entity string starts with
> 0-9 is enough. If you want to allow entity names to start with 0-9 as
> well (a bad idea IMHO), then you can be fancier and check if the entity
> string matches either [0-9]+ or 0[xX][0-9]+.

My 2 cents here: I would require that the first char for any entity 
to be a letter. Anyway, this should be aligned with uAPI spec.

Btw, I'm almost sure that " is mandatory: the OMAP entities have
space on their names.

> Assuming that brackets around the entity name are indeed not needed, then
> the only other annoying syntax is for rectangles: (left,top)/wxh.
> 
> The () also need to be quoted. I was wondering if the () around left,top are
> needed at all. Wouldn't left,top/WxH be sufficient? Rectangles are prefixed by
> crop: or compose:, so it's easy to know when you have to parse a rectangle.

IMO, here is one issue with media-ctl: IMO, the syntax for setting
links is very confusing[1]:

	$ media-ctl -v -r -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]' 
	(just picked a random example from stackoverflow)

[1] as a side note, IMHO, this syntax is obscure for humans, hard to parse
by the tool and doing it inside scripts is complex, as it would need to
double escape several things there, if you, for example, do things like using
a bash script that calls another bash script, or use ssh to send a media-ctl
setup line to a remote server.

I would very much prefer to have a file with something like
(I just preserved about the same syntax here, for didactic purposes):

	mt9v032 3-005c:0    -> OMAP3 ISP CCDC:0[1]
	OMAP3 ISP CCDC:2    -> OMAP3 ISP preview:0[1]
	OMAP3 ISP preview:1 -> OMAP3 ISP resizer:0[1]
	OMAP3 ISP resizer:1 -> OMAP3 ISP resizer output:0[1]

And then do something like:

	media-ctl-v2 set-links -f links_file

With regards to the syntax, my strong preference here would be to use something
that could be parsed with GraphViz, as one could do something like:

	media-ctl-v2 get-links -f file && cat file | dot -T png | display

Using GraphViz to view the topology. Then do whatever changes needed
to a text file (with could be viewed with GraphViz) and then import the
topology with media-ctl-v2.

Anyway, whatever syntax it uses, the best is to be sure that it would
internally be prepared to use a new ioctl that would allow doing everything
atomically.

Also, IMHO, it should be possible to do things like:

	echo "something" | media-ctl-v2 set-links

and:

	media-ctl-v2 set-links -f some_pipeline_settings_file

(so, instead of passing a complex command line, the topology would come
from either STDIN or via a file).

> I think that with these changes in place you can setup pipelines without
> having to care about escaping or quoting special characters.
> 
> My plan is to first convert media-ctl to C++ (with minimum changes) and
> start using v4l2-info.cpp and media-info.cpp to ensure consistent naming.
> 
> The next step is to support an easier alternative syntax, and finally
> G_TOPOLOGY support will be added to media-ctl so it has the same feature
> set as mc_nextgen_test.

My advice is to do the opposite: try first to implement G_TOPOLOGY
there. You'll then see how painful it is, and eventually decide if
it would be worth to drop the topology part of it in favor of using
a much simpler implementation at mc_nextgen_test (with also supports
v1 topology ioctls) or to simply start from scratch.

> Hopefully by the time that's done we'll also have properties, so that will
> be added as well.
> 
> I am uncertain what to do with libmediactl.c. It is only used by media-ctl,
> and it is never installed either. I am inclined to first make something
> that works, and then think about creating a proper library. Splitting off
> the parsing in a separate source is a good idea regardless, so I was
> planning to do that anyway.

IMO, the major issue with media-ctl is due to libmediactl.c. Trying to
do anything that would preserve the API there will be really painful
when implementing G_TOPOLOGY and would break API/ABI.

Also, IMHO, media-ctl.c carries a lot of stuff there just due to 
libmediactl, as it provides an "abstraction" from the Kernel structs
that actually doesn't really abstract (try to add G_TOPOLOGY support
there and you'll see what I mean), and adds a lot of code inside 
media-ctl in order to cope with the model.

If look at  my code, I actually encoded it with the goal to make it
a library. The only part there that is not part of a possible library
is the main() function and the parameter handling. So, if you decide
to reuse its code, you'll likely will get G_TOPOLOGY almost for free.

Thanks,
Mauro
