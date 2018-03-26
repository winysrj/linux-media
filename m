Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:13106 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751903AbeCZH6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 03:58:45 -0400
Date: Mon, 26 Mar 2018 10:58:42 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, acourbot@chromium.org
Subject: Re: [RFC v2 00/10] Preparing the request API
Message-ID: <20180326075842.fj4z6fkmuk3rppwo@paasikivi.fi.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
 <bc453725-e35d-77d4-c92f-27c37e9b3b5d@xs4all.nl>
 <2c969629-d69c-49b6-4cfc-a00e8157b070@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c969629-d69c-49b6-4cfc-a00e8157b070@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Mar 25, 2018 at 06:17:30PM +0200, Hans Verkuil wrote:
> On 03/25/2018 05:12 PM, Hans Verkuil wrote:
> > Hi all,
> > 
> > On 03/23/2018 10:17 PM, Sakari Ailus wrote:
> >> Hi folks,
> >>
> >> This preliminary RFC patchset prepares for the request API. What's new
> >> here is support for binding arbitrary configuration or resources to
> >> requests.
> >>
> >> There are a few new concepts here:
> >>
> >> Class --- a type of configuration or resource a driver (or e.g. the V4L2
> >> framework) can attach to a resource. E.g. a video buffer queue would be a
> >> class.
> >>
> >> Object --- an instance of the class. This may be either configuration (in
> >> which case the setting will stay until changed, e.g. V4L2 format on a
> >> video node) or a resource (such as a video buffer).
> >>
> >> Reference --- a reference to an object. If a configuration is not changed
> >> in a request, instead of allocating a new object, a reference to an
> >> existing object is used. This saves time and memory.
> >>
> >> I expect Laurent to comment on aligning the concept names between the
> >> request API and DRM. As far as I understand, the respective DRM names for
> >> "class" and "object" used in this set would be "object" and "state".
> >>
> >> The drivers will need to interact with the requests in three ways:
> >>
> >> - Allocate new configurations or resources. Drivers are free to store
> >>   their own data into request objects as well. These callbacks are
> >>   specific to classes.
> >>
> >> - Validate and queue callbacks. These callbacks are used to try requests
> >>   (validate only) as well as queue them (validate and queue). These
> >>   callbacks are media device wide, at least for now.
> >>
> >> The lifetime of the objects related to requests is based on refcounting
> >> both requests and request objects. This fits well for existing use cases
> >> whether or not based on refcounting; what still needs most of the
> >> attention is likely that the number of gets and puts matches once the
> >> object is no longer needed.
> >>
> >> Configuration can be bound to the request the usual way (V4L2 IOCTLs with
> >> the request_fd field set to the request). Once queued, request completion
> >> is signalled through polling the request file handle (POLLPRI).
> >>
> >> I'm posting this as an RFC because it's not complete yet. The code
> >> compiles but no testing has been done yet.
> > 
> > Thank you for this patch series. There are some good ideas here, but it is
> > quite far from being useful with Alexandre's RFCv4 series.
> > 
> > So this weekend I worked on a merger of this work and the RFCv4 Request API
> > patch series, taking what I think are the best bits of both.
> > 
> > It is available here:
> > 
> > https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv6
> 
> I reorganized/cleaned up the patch series. So look here instead:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv7

I looked at the set an I mostly agree with the changes. There are a few
comments I'd like to make --- and I didn't do a thorough review.

- The purpose of completeable objects is to help the driver to manage
  completing requests. Sometimes this is not self-evident. A request is
  complete when all of its results are available, including buffers and
  controls. The driver does not need to care about this. (I.e. this is not
  the same thing as refcounting.)

- I didn't immediately find object references in the latest set. The
  purpose of the references is to avoid copying objects if they don't
  change from requests to another. It's less time-consuming to allocate a
  new reference (a few pointers) instead of allocating memory for struct
  v4l2_format and copying the data. This starts to really matter when the
  number of objects increase.

  Then again, I wasn't very happy with videobufs having to refer
  themselves; perhaps we could limit referring to configuration objects
  (vs. resource objects; this is what my last patchset referred to as
  sticky; perhaps not a lasting name nor necessarily intended as such)
  while putting resource objects to the request itself.

  Controls would be a prime candidate for this if the control framework can
  be made to fit this model. I'm fine adding this later on, or another
  solution that avoids copying all unchanged configuration around for every
  request. But I want the need to be recognised so it won't come as a
  surprise to anyone later on.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
