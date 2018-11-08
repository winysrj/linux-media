Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45310 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeKHWBu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 17:01:50 -0500
Received: from [179.95.63.218] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gKjOK-0007gg-Me
        for linux-media@vger.kernel.org; Thu, 08 Nov 2018 12:26:33 +0000
Date: Thu, 8 Nov 2018 10:26:19 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: linux-media@vger.kernel.org
Subject: raw notes from the Media summit
Message-ID: <20181108102619.0a2b22bb@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to help writing a media summit report, I'm sending the raw notes
that were at Etherpad after the end of the meeting.

Thanks,
Mauro


Media summit 25-10-2018

Edinburgh
https://www.spinics.net/lists/linux-media/msg141095.html

Attendees

    Brad Love

    Ezequiel Garcia

    Gustavo Padovan

    Hans Verkuil

    Helen Koike

    Hidenori Yamaji

    Ivan Kalinin

    Jacopo Mondi

    Kieran Bingham

    Laurent Pinchart

    Mauro Chebab

    Maxime Ripard

    Michael Grzeschik

    Michael Ira Krufky

    Niklas S=C3=B6derlund

    Patrick Lai

    Paul Elder

    Peter Griffin

    Ralph Clark

    Ricardo Ribalda

    Sakari Ailus

    Sean Young

    Seung-Woo Kim

    Stefan Klug

    Vinod Koul



Topics

CEC (Hans Verkuil)

1 pin bus, cec-gpio error injection support
Tda998x (including BeagleBoard Bone support)
ChromeOS CEC support
DisplayPort CEC Tunneling over AUX for i915, nouveau, amdgpu
Still lots of work happening around CEC utilities, the compliance test is i=
n continuous use at cisco.
URL to CEC status: https://hverkuil.home.xs4all.nl/cec-status.txt

    CISCO using CEC in their products, and pushing for development of CEC u=
pstream.

    Automated test pipelines in place utilising cec-compliance


    1.4 spec can be found quite easily online (http://d1.amobbs.com/bbs_upl=
oad782111/files_51/ourdev_716302E34B9Q.pdf) - Hans will tell us diff to 2.0



RC-Core progress report (Sean Young)

    Ported/removed all staging lirc drivers

    BPF IR decoding support.

    rc-core protocol decoders only support the most common protocols

    old lirc userspace rarely required


Linux supports more IR hardware than any other operating system.

Future/TODO

    Some driver work needed (mostly for older hardware)

    Build dvb without rc-core

    More BPF protocol decoders

    Support 2.4ghz remotes

    Needs automated testing


Support with gpio and simple ir led is available

Persistent storage of controls (Ricardo Ribalda - Qtec)

Sensors usually come with some calibration data from the manufacturer about=
 dead pixels etc.
How to get this calibration data into the sensor.

proposal:=20
    - new vid interface /dev/videoX /dev/v4l-subX

        - s_ext_ctrls - write array of ctrls

    - s_ctrl - replace specfific ctrl

    - dt - locate ctrl vals

    - (reuse v4l2 ioctls for save/restore/get value(s))
    - implementation in two parts: main driver intf, storage

why not set sensor vals from userspace? - user might impl wrong

    - if part of driver can make sure they work for specific sensor


no get_min/max coz storage might not have space to save all ctrls

NVMEM might be good for storage rw
 - Is it a filesystem (or is that more overhead)
 - controls validate the data in the same way as they are validated by the =
device sensor.


Maintenance process tools - DIM (Laurent Pinchart - Ideas on Board)

DRM have switched to co-maintainer model
 - Burden is shared
 - Increased commit rights to the mainline (multi-maintaner model)
 - no enforeced maintainer process (each their own) - multi-comitter means =
each has to do checks - need to standardize tools -> DIM

    - DIM wrapper for git kindaish

 - DRM inglorious maintenance tool : https://01.org/linuxgraphics/gfx-docs/=
maintainer-tools/dim.html=20
 - conflict resolution by commiter, not maintainer
 - DIM uses conflict resoultion system in git to pre-prepare the merge conf=
licts in a shared cache.
 - tool enforces quality checks

drawbacks
- pushing =3D testing =3D rebuilding :/ -> becomes a burden for the committ=
ers

- Patches are integrated from a patchwork instance, and the commits then re=
ference the history of the patch upstream
- Adds an extra tool that must be used, and then an extra delay.

    - eg. takes time/difficult to ack


easyish to get commit rights
 - Responsibility to perform correctly
 - spreads the review workload (creates review-economics)

     - trading rb tags -> lower quality :/


- "please submit patches" "also please merge conflict resolution and rebuil=
d"
- If automated testing can validate the process, it can simplify commit pro=
cess for multi-commiters.

    - auto testing on test/build farm


had this model in media for a few years
- somebody merged 9k lines and lost a handful of devs
- probably exception, model fine
- many comitters but few maintainers - problem could be technically resolved

too few ppl reviewing patches - wait time measured in months :)
- multi-commiter model try to solve this problem

incentive to get more maintainers
- commit rights
- responsilibity - get attached to code :)


Automated testing (Ezequiel Garcia, Gustavo Padovan, Sakari Ailus)

Testing only one config, one version, one patch application, one hardware (=
one test to rule them all). Sometimes testing is omitted altogether by a de=
veloper, or it has been done before making changes to a patch. A lot of pro=
blems will only be found in the additional validation steps Mauro now perfo=
rms, or when the patches already have reached the master branch. We could d=
o better.

Ideal CI: patch submission -> auto test pass -> review +1, +2 -> merged! :)

Isn't the core question "what level of quality standards to we want to enfo=
rce" ? The maintainance process should be modelled around the answer to tha=
t question, not the other way around. Automated testing can be part of the =
quality standard enforcement procedure.

Three steps problem:

    Define the quality standards

    Define how to quantify them

    Define how to enforce them.


Automated testing is part of the enforcement.

Auto testing status

    Just v4l2- and cec- compliance

    Virtual device drivers (vivid, vimc, vicodec)

https://linuxtv.org/wiki/index.php/Media_Open_Source_Projects:_Looking_for_=
Volunteers


v4l2-compliance

The good:

* complete in terms of API testing
* quick and easy to run
* nice human readable machine parsable output
* new drivers are required to pass the test

The bad:

* no stateful/statless codec support
* no sdr and touch support
frequently updated
* only one contributor

Lack of a DVB: virtual driver and dvb-compliance. Added the need of write a=
 virtual driver and a DVB compliance tool in order to check Digital TV core=
 to the list of things to be done at https://linuxtv.org/wiki/index.php/Med=
ia_Open_Source_Projects:_Looking_for_Volunteers.=20

* Test format output consolidation (Test summit are working on this)

Ezequiel reported that some people are complaining that v4l2-compliance is =
updated too frequently, but this is unavoidable according to Hans. Mauro pr=
oposed moving v4l2-compliance to the kernel source tree but Hans prefers ke=
eping it separate as it makes it easier to develop it.

v4l2-compliance has a single contributor. We should push developers submitt=
ing new APIs to implement the corresponding tests. To achieve this we first=
 need to clean up the code base to make contributions easier. There is curr=
ently no internal API documentation, and source filies are quite big. Split=
ting code into separate unit tests could be useful.

There are still lots of compliance tests to be developped (MC-compliance fo=
r instance). Should we have them all in a single tool or in separate tools ?

Other test options

    kselftest

    Do we need a v4l2-compliance kselftest ?

    kunit

    gst-validate

    ktf (https://github.com/oracle/ktf, http://heim.ifi.uio.no/~knuto/ktf/)


Most of our tests are low-level, do we want high-level testing ?

e.g. gst-validate-1.0 --set-scenario pause_resume videotestsrc ! v4l2fwhten=
c ! v4l2fwhtdec ! fakevideosink

Testing of real hardware

    v4l2-compliance has basic support for testing that captured images don'=
t have colours swapped

    Testing real hardware adds dependencies on both hardware access and pos=
sibly control of the external environment (e.g. lightning). Is this out-of-=
scope for KernelCI ?


KernelCI

- kernel CI joining LinuxFoundation recently: extend test use cases and LTS
- UVC target of build integration testing (report on linux-media mailing li=
st: RFC)
- V4L testing first test beyond boot testing

https://www.mail-archive.com/linux-media@vger.kernel.org/msg135787.html

- MIssing components to identify driver under test
- test case in v4l2-compliance output parse
- Need to collaborate with kernelCI to decide test report frequency and tri=
ggering: eg. weekly report
- To discuss if report regressions only or new driver/features testing
- Tests could be run on any branch (but only triggered by changes: eg new c=
ommits)
- Test same branch with different configurations (eg. plain V4L2, V4L2+MC, =
DVB with no MC etc)
- Number of possible tests only depends on how many lab instances are avail=
able
- 32bit compliance test utility against a 64bit kernel.=20
- Might require simplying build of test tools (for different configurations=
, eg 32 vs 64 bits)
- Virtual machines used to run tests are LAVA slaves (created by LAVA itsel=
f)
- "Labs" instances are distributed and federated to KernelCI, each lab test=
s specific boards
- DRM uses custom FPGA (-not sure I got this right-) to compare actual outp=
ut wiht the expected one

Post-presentation talk on testing

    Testing master branch is not useful

    Problems MUST be found before the patches make it to the (sub-)maintain=
er trees, otherwise it's too late

    Testing developers' branches

    All branches in a tree

    Individual developers get their code tested, even before review on list=
=20

    Maintainers

    Merging rc-1 after release works the same way

    Test development branch that contains the rc-1, only then push to the m=
edia tree master branch

    Multiple trees for folks who have a large number of branches or branche=
s that are updated often which do not need to be tested


Eveyrone: reply Ezequiel's mail on the list!

Stateless codecs

Support for stateless codecs will be merged for v4.20 as a staging driver b=
eing used by AllWinner
how to support in userspace?

bit parsing is application-specific - so there's no point in providing it

should there be simple parser for compliance-testing?

All main applications support libva, developed originally by Intel to provi=
de access to their accelerators.
libva backend was written for stateless cedrus decoder

Mainly allwinner, but some work on Rockchip stateless codec

Requirements for removal from staging is at least one other decoder and enc=
oder using the API.
API is not stable atm so should expect it to change.



V4L2 Create better ioctls

VIDIOC_G/S_PARM - really only used for get/set frameinterval

    - add VIDIOC_G/S_FRAME_INTERVAL

    - Just use the existing IOCTL argument memory layout, but rework the st=
ruct and rename it (for compatibility reasons the old IOCTL stays)


why separate API to set ctrl?

    Input number


VIDIOC_ENUM_FRAMEINTERVALS

struct v4l2_frmivalenum

    - why have stepwise? - makes little sense for frame intervals

    - Stepwise could be removed (Qualcomm venus codec and uvc only users)

    - Add more types to tell the unit

    - add buf_type field in struct v4l2_frmivalenum and struct v4l2_frmsize=
enum


ns vs fracs=20

    - frac more precise

    - but ns is unambiguous

    - Facebook(OculusVR) defined a 'flick' as a common denominator of all v=
alues :=20

    https://techcrunch.com/2018/01/22/facebook-invented-a-new-time-unit-cal=
led-the-flick-and-its-truly-amazing/

    https://github.com/OculusVR/Flicks


Combine ENUM_FMT, ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS

make ioctl to combine all three that returns all possiblities/combinations =
wihout having to enumerate everything
is it worth the effort? - might be big eg. vivid 1710 combinations

- Memory requirements of the argument are not an issue as such: video buffe=
rs will require more memory anyway.
- Don't change now. But revisit, if any of the following happens

    - Larger (or new) IOCTL struct is needed for any of the IOCTLs

    - If this turns out to be a performance issue somewhere


struct v4l2_buffer

problems:
- timestamp is not 2038-safe
- planes - single vs multi plane handing is really different and a mess

proposal: new struct v4l2_buffer
- __u64 timestamp

    - struct timeval could be remade - but then need to recompile - u64 sim=
pler - also simplifies for single-multi-planar issue - modernization

    - support for 2038-safe struct v4l2_buffer needed in any case

- struct v4l2_ext_plane planes[VIDEO_MAX_PLANES] - put planes arraywithint =
struct v4l2_buffer
ideas:
    - improve plane description: offset at start of plane, padding at end o=
f plane, fd refer to one or all planes (-1 for remaining if allowed by SoC,=
 eg exynos4)

    - simplify codecs resolution change - add width/height for buffer?

    - per-plane pixelformat? - maybe not? (video and non-video in same buff=
er?)

    - get rid of difference between single and multiplanar - multiplanar be=
coming more normal

    - Currently the driver needs to pick which one to support. Compatibilit=
y support for the single-planar API was merged but later removed? Re-introd=
uce it?


struct v4l2_create_buffers

only format.pix.sizeimage is used
want to simplify - coz struct v4l2_format is kinda big
- Create buffers one at a time

    - non-contiguous range; need to tell the index of the allocated buffer

    - nicely symmentrical to deleting buffers one at a time


proposal: more generic stuff:
    - VIDIOC_CREATE_BUF - with just size per plane instead of format (if 0 =
then use current format's size like REQBUFS)
    - VIDIOC_DELETE_BUF <- currently canoot be done at all, might need it i=
n a few years anyway
    - VIDIOC_DELETE_ALL_BUFS

struct v4l2_format and VIDIOC_G/S/TRY_FMT

v4l2_pix_format vs v4l2_pix_format-mplane - painful

...that's it?


Fault Tolerant V4L2

problem: 8 cameras, one dies, they all cannot be used :/

V4L2 designed to work only when all devs working - but still need fault tol=
erance :/

- Media events to tell when new devices appear
- A change in the graph increments the media graph version number (G_TOPOLO=
GY IOCTL)
- Way to tell the user whether the registration is complete or not

    - Events are not enough: the application may not have subscribed such a=
n event before it arrives

    - Media device info flag?

    - The property API might be usable for the purpose --- placeholders for=
 entities that have not yet appeared?

    - Known enitites which are failed can be created in the Media Graph and=
 marked disabled or 'failed'

    - Those entities could then have an operation to 'reprobe'

    - Events should be available on the media node - but the API should als=
o be able to query state.



Complex Cameras

how to make generic apps work with complex hw and mc -> libcamera

we gonna have more complex cameras in notebooks coz easier/cheaper to make
- so we need to do this or else we're going to lose laptop webcams

dev process

complaints?
- ppl want recognition for being involved - have intermediate multicommit t=
ree?

    - ask ppl if they want commit rights rather than ask them to review

    - need rules for multicommit - technical, not ethical

    - maintainers > committers -> maintainers discuss before making decisio=
ns

- commit-to-master rights vs merge rights

Linuxtv.org

- Hosted in a virtual machine somewhere in a German university
- The long term need is to move the virtual machine elsewhere




Thanks,
Mauro
