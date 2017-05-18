Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45788 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755090AbdERWiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 18:38:50 -0400
Date: Fri, 19 May 2017 01:38:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        niklas.soderlund@ragnatech.se, geert@glider.be,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3.1 1/2] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
Message-ID: <20170518223814.GB3227@valkosipuli.retiisi.org.uk>
References: <cover.ed561929790222fc2c4467d4e57072a8e4ba69f3.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
 <1676271.nErFi1MvTr@avalon>
 <20170518210517.GX3227@valkosipuli.retiisi.org.uk>
 <5179234.LRh3vaxPHy@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179234.LRh3vaxPHy@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, May 19, 2017 at 12:59:12AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 19 May 2017 00:05:17 Sakari Ailus wrote:
> > On Thu, May 18, 2017 at 11:54:46PM +0300, Laurent Pinchart wrote:
> > > On Thursday 18 May 2017 23:50:34 Sakari Ailus wrote:
> > >> On Thu, May 18, 2017 at 07:08:00PM +0300, Laurent Pinchart wrote:
> > >>> On Wednesday 17 May 2017 22:20:57 Sakari Ailus wrote:
> > >>>> On Wed, May 17, 2017 at 04:38:14PM +0100, Kieran Bingham wrote:
> > >>>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > >>>>> 
> > >>>>> Return NULL, if a null entity is parsed for it's v4l2_subdev
> > >>>>> 
> > >>>>> Signed-off-by: Kieran Bingham
> > >>>>> <kieran.bingham+renesas@ideasonboard.com>
> > >>>>> ---
> > >>>>> 
> > >>>>>  include/media/v4l2-subdev.h | 2 +-
> > >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>>>> 
> > >>>>> diff --git a/include/media/v4l2-subdev.h
> > >>>>> b/include/media/v4l2-subdev.h
> > >>>>> index 5f1669c45642..72d7f28f38dc 100644
> > >>>>> --- a/include/media/v4l2-subdev.h
> > >>>>> +++ b/include/media/v4l2-subdev.h
> > >>>>> @@ -829,7 +829,7 @@ struct v4l2_subdev {
> > >>>>>  };
> > >>>>>  
> > >>>>>  #define media_entity_to_v4l2_subdev(ent) \
> > >>>>> -	container_of(ent, struct v4l2_subdev, entity)
> > >>>>> +	(ent ? container_of(ent, struct v4l2_subdev, entity) : NULL)
> > >>>>>  #define vdev_to_v4l2_subdev(vdev) \
> > >>>>>  	((struct v4l2_subdev *)video_get_drvdata(vdev))
> > >>>> 
> > >>>> The problem with this is that ent is now referenced twice. If the ent
> > >>>> macro argument has side effect, this would introduce bugs. It's
> > >>>> unlikely, but worth avoiding. Either use a macro or a function.
> > >>>> 
> > >>>> I think I'd use function for there's little use for supporting for
> > >>>> const and non-const arguments presumably. A simple static inline
> > >>>> function should do.
> > >>> 
> > >>> Note that, if we want to keep using a macro, this could be written as
> > >>> 
> > >>> #define media_entity_to_v4l2_subdev(ent) ({ \
> > >>> 	typeof(ent) __ent = ent; \
> > > 
> > > I just realized that this should be written
> > > 
> > >  	typeof(ent) __ent = (ent);
> > 
> > I don't think that really makes much of a difference. It's a little bit
> > safer still perhaps. I don't remember having seen a case where the function
> > argument would have required parentheses there though.
> > 
> > >>> 	__ent ? container_of(__ent, struct v4l2_subdev, entity) : NULL; \
> > >>> 
> > >>> })
> > >>> 
> > >>> Bonus point if you can come up with a way to return a const struct
> > >>> v4l2_subdev pointer when then ent argument is const.
> > >> 
> > >> I can't think of a use case for that. I've never seen a const struct
> > >> v4l2_subdev anywhere. I could be just oblivious though. :-)
> > > 
> > > I agree with you, it's overkill, at least for now. Although I'd like to
> > > see how it could be done, for other similar constructs where both const
> > > and non- const versions are useful.
> > 
> > Yes, that approach is fine. Another example here (not merged yet):
> > 
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=of&id=1461f5172
> > d40c1c4632bcb457e5f580836922879>
> 
> The problem here is that the container_of() macro ends up casting the argument 
> to a struct v4l2_subdev *, regardless of whether the original pointer was 
> const or not.

Uh, good point. Hmm.

> 
> > > > Better give a __ent a name that someone will not accidentally come up
> > > > with. That can lead to problems that are difficult to debug --- for the
> > > > code compiles, it just doesn't do what's expected.
> > > 
> > > Won't it generate a compilation error as the variable would be redefined
> > > by the macro ?
> > 
> > It's perfectly fine redefine local variables.
> 
> Of course, my bad. As the local __ent variable would shadow any variable of 
> the same name declared in a parent context, the only case where this would 
> cause a problem is if the ent argument to the macro references the __ent 
> variable. In the simplest case, if the ent argument is __ent, the construct 
> would lead to
> 
> 	typeof(__ent) __ent = (__ent);
> 
> which interestingly enough compiles without generating a warning, but 
> generates incorrect code. Various macros in kernel.h seem to be subject to the 
> same problem.
> 
> Do you have a suggestion for a better variable name ?

Documentation/process/coding-style.rst around line 760 is helpful:

5) namespace collisions when defining local variables in macros resembling
functions:

.. code-block:: c

        #define FOO(x)                          \
	({                                      \
     		typeof(x) ret;			\
		ret = calc_ret(x);		\
                (ret);                          \
        })

ret is a common name for a local variable - __foo_ret is less likely
to collide with an existing variable.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
