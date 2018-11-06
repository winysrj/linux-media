Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50034 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbeKFWhT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 17:37:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [RFC] Create test script(s?) for regression testing
Date: Tue, 06 Nov 2018 15:12:19 +0200
Message-ID: <1795902.nUhofaO05U@avalon>
In-Reply-To: <20181106113654.dhindu3lgaks74rr@paasikivi.fi.intel.com>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl> <20181106113654.dhindu3lgaks74rr@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, 6 November 2018 13:36:55 EET Sakari Ailus wrote:
> On Tue, Nov 06, 2018 at 09:37:07AM +0100, Hans Verkuil wrote:
> > Hi all,
> > 
> > After the media summit (heavy on test discussions) and the V4L2 event
> > regression we just found it is clear we need to do a better job with
> > testing.
> > 
> > All the pieces are in place, so what is needed is to combine it and create
> > a script that anyone of us as core developers can run to check for
> > regressions. The same script can be run as part of the kernelci
> > regression testing.
> 
> I'd say that *some* pieces are in place. Of course, the more there is, the
> better.
> 
> The more there are tests, the more important it would be they're automated,
> preferrably without the developer having to run them on his/her own
> machine.

>From my experience with testing, it's important to have both a core set of 
tests (a.k.a. smoke tests) that can easily be run on developers' machines, and 
extended tests that can be offloaded to a shared testing infrastructure (but 
possibly also run locally if desired).

> > We have four virtual drivers: vivid, vim2m, vimc and vicodec. The last one
> > is IMHO not quite good enough yet for testing: it is not fully compliant
> > to the upcoming stateful codec spec. Work for that is planned as part of
> > an Outreachy project.
> > 
> > My idea is to create a script that is maintained as part of v4l-utils that
> > loads the drivers and runs v4l2-compliance and possibly other tests
> > against the virtual drivers.
> 
> How about spending a little time to pick a suitable framework for running
> the tests? It could be useful to get more informative reports than just
> pass / fail.

We should keep in mind that other tests will be added later, and the test 
framework should make that easy.

Regarding the test output, many formats exist (see https://testanything.org/ 
and https://chromium.googlesource.com/chromium/src/+/master/docs/testing/
json_test_results_format.md for instance), we should pick one of the leading 
industry standards (what those standards are still needs to be researched 
:-)).

> Do note that for different hardware the tests would be likely different as
> well although there are classes of devices for which the exact same tests
> would be applicable.

See http://git.ideasonboard.com/renesas/vsp-tests.git for an example of 
device-specific tests. I think some of that could be generalized.

> > It should be simple to use and require very little in the way of
> > dependencies. Ideally no dependencies other than what is in v4l-utils so
> > it can easily be run on an embedded system as well.
> > 
> > For a 64-bit kernel it should run the tests both with 32-bit and 64-bit
> > applications.
> > 
> > It should also test with both single and multiplanar modes where
> > available.
> > 
> > Since vivid emulates CEC as well, it should run CEC tests too.
> > 
> > As core developers we should have an environment where we can easily test
> > our patches with this script (I use a VM for that).
> > 
> > I think maintaining the script (or perhaps scripts) in v4l-utils is best
> > since that keeps it in sync with the latest kernel and v4l-utils
> > developments.
> 
> Makes sense --- and that can be always changed later on if there's a need
> to.

I wonder whether that would be best going forward, especially if we want to 
add more tests. Wouldn't a v4l-tests project make sense ?

-- 
Regards,

Laurent Pinchart
