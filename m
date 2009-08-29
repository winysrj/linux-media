Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39784 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZH2BHp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 21:07:45 -0400
Subject: [Fwd: How to debug problem with Playstation Eye webcam?]
From: Andy Walls <awalls@radix.net>
To: Tim Bird <tim.bird@am.sony.com>, linux-media@vger.kernel.org
Cc: ospite@studenti.unina.it
Content-Type: text/plain
Date: Fri, 28 Aug 2009 21:10:03 -0400
Message-Id: <1251508203.3200.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim,

The video4linux-list is obsolete.  You are more likely to get help at
linux-media@vger.kernel.org

Regards,
Andy

-------- Forwarded Message --------
From: Tim Bird <tim.bird@am.sony.com>
To: video4linux-list@redhat.com
Cc: ospite@studenti.unina.it
Subject: How to debug problem with Playstation Eye webcam?
Date: Fri, 28 Aug 2009 14:41:34 -0700

I'm trying to get a Playstation Eye webcam working under a new install of
Fedora 11 and not having much luck.

I'm running a stock Fedora kernel (2.6.29.4).

When I plug in the device, /dev/video0 is created, and the modules
gspca_main and gspca_ov534 are loaded into the kernel.

The device responds to QUERYCAP and other interrogation commands
from user space, but when my test program actually tries to read
the device, I get a multi-second delay, and an eventual
errno of EIO.

I ran v4l-test version 0.19, and some tests succeeded and others failed.
Results are shown below.  Note that I had to disable the test
"VIDIOC_G_CTRL with NULL parameter", because that resulted in a hang
of v4l-test when run against the 'Eye' webcam.

A logitech web camera has mixed results from v4l-test as well
(succeeding and failing in different places from the Playstation Eye).
But the logitech works fine with my test program and a variety of
other programs.

I'm not sure where to look next to continue debugging this.
I assume that the general relationship of components is:
test program ->linux kernel -> gspca main driver ->
	USB and ov534 driver -> USB and camera hardware

Any tips for how to figure out where the problem might be,
reports of previous experience with this webcam, or additional
diagnostic tools or techniques would be much appreciated.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

Here are results from v4l-test for the Playstation Eye (with one
test disabled):

     CUnit - A Unit testing framework for C - Version 2.1-0
     http://cunit.sourceforge.net/


Suite: VIDIOC_QUERYCAP
  Test: VIDIOC_QUERYCAP ... passed
  Test: VIDIOC_CROPCAP ... passed
  Test: VIDIOC_CROPCAP with different inputs ... passed
  Test: VIDIOC_G_SLICED_VBI_CAP ... passed
  Test: VIDIOC_G_SLICED_VBI_CAP with invalid types ... passed
Suite: VIDIOC_ENUM* ioctl calls
  Test: VIDIOC_ENUMAUDIO ... passed
  Test: VIDIOC_ENUMAUDIO, index=S32_MAX ... passed
  Test: VIDIOC_ENUMAUDIO, index=S32_MAX+1 ... passed
  Test: VIDIOC_ENUMAUDIO, index=U32_MAX ... passed
  Test: VIDIOC_ENUMAUDOUT ... passed
  Test: VIDIOC_ENUMAUDOUT, index=S32_MAX ... passed
  Test: VIDIOC_ENUMAUDOUT, index=S32_MAX+1 ... passed
  Test: VIDIOC_ENUMAUDOUT, index=U32_MAX ... passed
  Test: VIDIOC_ENUM_FMT ... passed
  Test: VIDIOC_ENUM_FMT, index=S32_MAX ... passed
  Test: VIDIOC_ENUM_FMT, index=S32_MAX+1 ... passed
  Test: VIDIOC_ENUM_FMT, index=U32_MAX ... passed
  Test: VIDIOC_ENUM_FMT, invalid type ... passed
  Test: VIDIOC_ENUMINPUT ... passed
  Test: VIDIOC_ENUMINPUT, index=S32_MAX ... passed
  Test: VIDIOC_ENUMINPUT, index=S32_MAX+1 ... passed
  Test: VIDIOC_ENUMINPUT, index=U32_MAX ... passed
  Test: VIDIOC_ENUMOUTPUT ... passed
  Test: VIDIOC_ENUMOUTPUT, index=S32_MAX ... passed
  Test: VIDIOC_ENUMOUTPUT, index=S32_MAX+1 ... passed
  Test: VIDIOC_ENUMOUTPUT, index=U32_MAX ... passed
  Test: VIDIOC_ENUMSTD ... passed
  Test: VIDIOC_ENUMSTD, index=S32_MAX ... passed
  Test: VIDIOC_ENUMSTD, index=S32_MAX+1 ... passed
  Test: VIDIOC_ENUMSTD, index=U32_MAX ... passed
  Test: VIDIOC_QUERYCTRL ... passed
  Test: VIDIOC_QUERYCTRL, id=V4L2_CID_BASE-1 ... passed
  Test: VIDIOC_QUERYCTRL, id=V4L2_CID_LASTP1 ... passed
  Test: VIDIOC_QUERYCTRL, id=V4L2_CID_LASTP1+1 ... passed
  Test: VIDIOC_QUERYCTRL with V4L2_CTRL_FLAG_NEXT_CTRL ... passed
  Test: VIDIOC_QUERYCTRL, enumerate private controls ... passed
  Test: VIDIOC_QUERYCTRL, V4L2_CID_PRIVATE_BASE-1 ... passed
  Test: VIDIOC_QUERYCTRL, last private control+1 ... passed
  Test: VIDIOC_QUERYMENU ... passed
  Test: VIDIOC_QUERYMENU with invalid id ... passed
  Test: VIDIOC_QUERYMENU with private controls ... passed
  Test: VIDIOC_QUERYMENU, last private control+1 ... passed
  Test: VIDIOC_ENUM_FRAMESIZES ... passed
  Test: VIDIOC_ENUM_FRAMESIZES with invalid index ... passed
  Test: VIDIOC_ENUM_FRAMESIZES with invalid pixel_format ... passed
Suite: VIDIOC_G_*, VIDIOC_S_* and VIDIOC_TRY_* ioctl calls
  Test: VIDIOC_G_STD ... FAILED
    1. test_VIDIOC_STD.c:79  - CU_ASSERT_EQUAL(ret_std_get,-1)
  Test: VIDIOC_S_STD with the enumerated values ... FAILED
    1. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    2. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
  Test: VIDIOC_S_STD ... FAILED
    1. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    2. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    3. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    4. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    5. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    6. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    7. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    8. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    9. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    10. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    11. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    12. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    13. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    14. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    15. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    16. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    17. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    18. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    19. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    20. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    21. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    22. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    23. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    24. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    25. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    26. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    27. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    28. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    29. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    30. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    31. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    32. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    33. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    34. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    35. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    36. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    37. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    38. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    39. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    40. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    41. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    42. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    43. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    44. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    45. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    46. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    47. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    48. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    49. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    50. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    51. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    52. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    53. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    54. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
  Test: VIDIOC_S_STD with invalid standard ... FAILED
    1. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    2. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    3. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    4. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    5. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    6. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    7. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    8. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    9. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    10. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    11. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    12. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    13. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    14. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    15. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    16. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    17. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    18. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    19. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    20. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    21. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    22. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    23. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    24. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    25. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    26. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    27. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    28. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    29. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    30. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    31. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    32. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    33. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    34. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    35. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    36. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    37. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    38. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    39. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    40. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    41. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    42. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    43. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    44. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    45. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    46. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    47. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    48. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    49. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    50. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    51. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    52. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    53. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    54. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    55. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    56. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    57. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    58. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    59. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    60. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    61. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    62. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    63. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    64. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    65. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    66. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    67. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    68. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    69. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    70. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    71. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    72. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    73. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    74. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    75. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    76. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    77. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    78. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    79. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    80. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    81. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    82. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    83. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    84. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    85. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    86. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    87. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    88. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    89. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    90. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    91. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    92. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    93. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    94. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    95. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    96. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    97. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    98. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    99. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    100. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    101. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    102. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    103. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    104. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    105. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    106. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    107. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    108. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    109. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    110. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    111. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    112. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    113. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
    114. test_VIDIOC_STD.c:323  - CU_ASSERT_EQUAL(ret_set,-1)
    115. test_VIDIOC_STD.c:154  - CU_ASSERT_EQUAL(ret_std_get,-1)
    116. test_VIDIOC_STD.c:156  - CU_ASSERT_EQUAL(ret_std_set,-1)
  Test: VIDIOC_G_INPUT ... passed
  Test: VIDIOC_S_INPUT from enum ... passed
  Test: VIDIOC_S_INPUT with invalid inputs ... passed
  Test: VIDIOC_G_OUTPUT ... passed
  Test: VIDIOC_S_OUTPUT from enum ... passed
  Test: VIDIOC_S_OUTPUT with invalid outputs ... passed
  Test: VIDIOC_G_TUNER ... passed
  Test: VIDIOC_G_TUNER, index=S32_MAX ... passed
  Test: VIDIOC_G_TUNER, index=S32_MAX+1 ... passed
  Test: VIDIOC_G_TUNER, index=U32_MAX ... passed
  Test: VIDIOC_S_TUNER ... passed
  Test: VIDIOC_S_TUNER with invalid index and audmode parameters ... passed
  Test: VIDIOC_G_MODULATOR ... passed
  Test: VIDIOC_G_MODULATOR, index=S32_MAX ... passed
  Test: VIDIOC_G_MODULATOR, index=S32_MAX+1 ... passed
  Test: VIDIOC_G_MODULATOR, index=U32_MAX ... passed
  Test: VIDIOC_G_FREQUENCY ... passed
  Test: VIDIOC_G_FREQUENCY, tuner=S32_MAX ... passed
  Test: VIDIOC_G_FREQUENCY, tuner=S32_MAX+1 ... passed
  Test: VIDIOC_G_FREQUENCY, tuner=U32_MAX ... passed
  Test: VIDIOC_S_FREQUENCY ... passed
  Test: VIDIOC_S_FREQUENCY with boundary values ... passed
  Test: VIDIOC_S_FREQUENCY scan all possbile values ... passed
  Test: VIDIOC_G_PRIORITY ... passed
  Test: VIDIOC_S_PRIORITY ... passed
  Test: VIDIOC_S_PRIORITY with invalid values ... passed
  Test: VIDIOC_G_AUDIO ... passed
  Test: VIDIOC_G_AUDIO, ignore index value ... passed
  Test: VIDIOC_S_AUDIO ... passed
  Test: VIDIOC_S_AUDIO, index=S32_MAX ... passed
  Test: VIDIOC_S_AUDIO, index=S32_MAX+1 ... passed
  Test: VIDIOC_S_AUDIO, index=U32_MAX ... passed
  Test: VIDIOC_G_AUDOUT ... passed
  Test: VIDIOC_G_AUDOUT, ignore index value ... passed
  Test: VIDIOC_S_AUDOUT ... passed
  Test: VIDIOC_S_AUDOUT, index=S32_MAX ... passed
  Test: VIDIOC_S_AUDOUT, index=S32_MAX+1 ... passed
  Test: VIDIOC_S_AUDOUT, index=U32_MAX ... passed
  Test: VIDIOC_G_CROP ... passed
  Test: VIDIOC_G_CROP with invalid type ... passed
  Test: VIDIOC_S_CROP ... passed
  Test: VIDIOC_S_CROP with invalid type ... passed
  Test: VIDIOC_G_CTRL ... passed
  Test: VIDIOC_S_CTRL ... passed
  Test: VIDIOC_S_CTRL with invalid value parameter ... passed
  Test: VIDIOC_S_CTRL, withe balance ... passed
  Test: VIDIOC_S_CTRL, white balance with invalid value parameter ... passed
  Test: VIDIOC_S_CTRL, gain control ... passed
  Test: VIDIOC_S_CTRL, gain control with invalid value parameter ... passed
  Test: VIDIOC_G_EXT_CTRLS with zero items to get ... passed
  Test: VIDIOC_G_EXT_CTRLS with zero items to get, but with invalid count values ... passed
  Test: VIDIOC_G_EXT_CTRLS with only one item to get ... passed
  Test: VIDIOC_S_EXT_CTRLS with zero items to set ... passed
  Test: VIDIOC_S_EXT_CTRLS with zero items to set, but with invalid count values ... passed
  Test: VIDIOC_TRY_EXT_CTRLS with zero items to try ... passed
  Test: VIDIOC_TRY_EXT_CTRLS with zero items to try, but with invalid count values ... passed
  Test: VIDIOC_G_PARM ... passed
  Test: VIDIOC_G_PARM with invalid type parameter ... passed
  Test: VIDIOC_G_FMT ... passed
  Test: VIDIOC_G_FMT with invalid type parameter ... passed
  Test: VIDIOC_S_FMT with enumerated values ... FAILED
    1. test_VIDIOC_FMT.c:771  - CU_ASSERT_EQUAL(memcmp(format_max.fmt.raw_data+sizeof(format_max.fmt.pix), format2.fmt.raw_data+sizeof(format2.fmt.pix),
sizeof(format_max.fmt.raw_data)-sizeof(format_max.fmt.pix)),0)
    2. test_VIDIOC_FMT.c:723  - CU_ASSERT_EQUAL(ret_enum,0)
    3. test_VIDIOC_FMT.c:755  - CU_ASSERT_EQUAL(format_max.fmt.pix.pixelformat,fmtdesc.pixelformat)
    4. test_VIDIOC_FMT.c:771  - CU_ASSERT_EQUAL(memcmp(format_max.fmt.raw_data+sizeof(format_max.fmt.pix), format2.fmt.raw_data+sizeof(format2.fmt.pix),
sizeof(format_max.fmt.raw_data)-sizeof(format_max.fmt.pix)),0)
    5. test_VIDIOC_FMT.c:790  - CU_ASSERT_EQUAL(ret_enum,0)
    6. test_VIDIOC_FMT.c:822  - CU_ASSERT_EQUAL(format_min.fmt.pix.pixelformat,fmtdesc.pixelformat)
  Test: VIDIOC_S_FMT with invalid type parameter ... passed
  Test: VIDIOC_G_JPEGCOMP ... passed
  Test: VIDIOC_G_ENC_INDEX ... passed
Suite: VIDIOC_QUERYSTD
  Test: VIDIOC_QUERYSTD ... passed
Suite: buffer i/o
  Test: VIDIOC_REQBUFS with memory map capture streaming i/o ... FAILED
    1. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    2. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    3. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    4. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    5. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    6. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    7. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    8. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    9. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    10. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    11. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    12. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    13. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    14. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    15. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    16. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
    17. test_VIDIOC_REQBUFS.c:67  - CU_ASSERT_EQUAL(reqbuf.reserved[0],0)
    18. test_VIDIOC_REQBUFS.c:68  - CU_ASSERT_EQUAL(reqbuf.reserved[1],0)
  Test: VIDIOC_REQBUFS with user pointer capture streaming i/o ... FAILED
    1. test_VIDIOC_REQBUFS.c:140  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    2. test_VIDIOC_REQBUFS.c:140  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    3. test_VIDIOC_REQBUFS.c:140  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    4. test_VIDIOC_REQBUFS.c:140  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    5. test_VIDIOC_REQBUFS.c:140  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    6. test_VIDIOC_REQBUFS.c:140  - CU_ASSERT_EQUAL(errno_req,EINVAL)
  Test: VIDIOC_REQBUFS with memory map output streaming i/o ... passed
  Test: VIDIOC_REQBUFS with user pointer output streaming i/o ... passed
  Test: VIDIOC_REQBUFS with invalid memory parameter, capture ... passed
  Test: VIDIOC_REQBUFS with invalid memory parameter, output ... passed
  Test: VIDIOC_REQBUFS with invalid type parameter, memory mapped i/o ... passed
  Test: VIDIOC_REQBUFS with invalid type parameter, user pointer i/o ... passed
  Test: VIDIOC_QUERYBUF with memory map capture streaming i/o ... passed
  Test: VIDIOC_QUERYBUF with user pointer capture streaming i/o ... FAILED
    1. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    2. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    3. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    4. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    5. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    6. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    7. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    8. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    9. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    10. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    11. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    12. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    13. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    14. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    15. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    16. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    17. test_VIDIOC_QUERYBUF.c:70  - CU_ASSERT_EQUAL(errno_req,EINVAL)
    18. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
  Test: VIDIOC_QUERYBUF with memory map output streaming i/o ... passed
  Test: VIDIOC_QUERYBUF with user pointer output streaming i/o ... passed
  Test: VIDIOC_QUERYBUF with overlay capture (invalid) ... FAILED
    1. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
  Test: VIDIOC_QUERYBUF with overlay output (invalid) ... passed
  Test: VIDIOC_QUERYBUF with invalid memory parameter, capture ... FAILED
    1. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    2. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    3. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
    4. test_VIDIOC_QUERYBUF.c:222  - CU_ASSERT_EQUAL(ret_req,-1)
  Test: VIDIOC_QUERYBUF with invalid memory parameter, output ... passed
  Test: VIDIOC_QUERYBUF with invalid type parameter, memory mapped i/o ... passed
  Test: VIDIOC_QUERYBUF with invalid type parameter, user pointer i/o ... passed
Suite: read only IOCTLs with NULL parameter
  Test: VIDIOC_QUERYCAP with NULL parameter ... passed
  Test: VIDIOC_G_STD with NULL parameter ... FAILED
    1. test_VIDIOC_STD.c:372  - CU_ASSERT_EQUAL(ret_get,-1)
    2. test_VIDIOC_STD.c:373  - CU_ASSERT_EQUAL(errno_get,EINVAL)
    3. test_VIDIOC_STD.c:375  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_G_AUDIO with NULL parameter ... passed
  Test: VIDIOC_G_INPUT with NULL parameter ... passed
  Test: VIDIOC_G_OUTPUT with NULL parameter ... passed
  Test: VIDIOC_G_AUDOUT with NULL parameter ... passed
  Test: VIDIOC_G_JPEGCOMP with NULL parameter ... passed
  Test: VIDIOC_QUERYSTD with NULL parameter ... passed
  Test: VIDIOC_G_PRIORITY with NULL parameter ... passed
  Test: VIDIOC_G_ENC_INDEX with NULL parameter ... passed
Suite: write only IOCTLs with NULL parameter
  Test: VIDIOC_S_STD with NULL parameter ... FAILED
    1. test_VIDIOC_STD.c:426  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_S_TUNER with NULL parameter ... FAILED
    1. test_VIDIOC_TUNER.c:513  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_S_AUDIO with NULL parameter ... passed
  Test: VIDIOC_S_AUDOUT with NULL parameter ... FAILED
    1. test_VIDIOC_AUDOUT.c:456  - CU_ASSERT_EQUAL(errno_set,EINVAL)
  Test: VIDIOC_S_FREQUENCY with NULL parameter ... FAILED
    1. test_VIDIOC_FREQUENCY.c:732  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_S_CROP with NULL parameter ... FAILED
    1. test_VIDIOC_CROP.c:835  - CU_ASSERT_EQUAL(errno_null,EINVAL)
    2. test_VIDIOC_CROP.c:835  - CU_ASSERT_EQUAL(errno_null,EINVAL)
    3. test_VIDIOC_CROP.c:835  - CU_ASSERT_EQUAL(errno_null,EINVAL)
    4. test_VIDIOC_CROP.c:835  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_S_PRIORITY with NULL parameter ... FAILED
    1. test_VIDIOC_PRIORITY.c:272  - CU_ASSERT_EQUAL(errno_null,EINVAL)
Suite: write and read IOCTLs with NULL parameter
  Test: VIDIOC_ENUM_FMT with NULL parameter ... passed
  Test: VIDIOC_G_FMT with NULL parameter ... passed
  Test: VIDIOC_G_PARM with NULL parameter ... passed
  Test: VIDIOC_ENUMSTD with NULL parameter ... FAILED
    1. test_VIDIOC_ENUMSTD.c:205  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_ENUMINPUT with NULL parameter ... passed
  Test: VIDIOC_S_CTRL with NULL parameter ... passed
  Test: VIDIOC_G_TUNER with NULL parameter ... FAILED
    1. test_VIDIOC_TUNER.c:292  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_QUERYCTRL with NULL parameter ... FAILED
    1. test_VIDIOC_QUERYCTRL.c:664  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_QUERYMENU with NULL parameter ... FAILED
    1. test_VIDIOC_QUERYMENU.c:386  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_S_INPUT with NULL parameter ... passed
  Test: VIDIOC_S_OUTPUT with NULL parameter ... FAILED
    1. test_VIDIOC_OUTPUT.c:276  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_ENUMOUTPUT with NULL parameter ... FAILED
    1. test_VIDIOC_ENUMOUTPUT.c:196  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_G_MODULATOR with NULL parameter ... FAILED
    1. test_VIDIOC_MODULATOR.c:235  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_G_FREQUENCY with NULL parameter ... FAILED
    1. test_VIDIOC_FREQUENCY.c:177  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_CROPCAP with NULL parameter ... FAILED
    1. test_VIDIOC_CROPCAP.c:279  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_G_CROP with NULL parameter ... FAILED
    1. test_VIDIOC_CROP.c:141  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_ENUMAUDIO with NULL parameter ... passed
  Test: VIDIOC_ENUMAUDOUT with NULL parameter ... FAILED
    1. test_VIDIOC_ENUMAUDOUT.c:193  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_G_SLICED_VBI_CAP with NULL parameter ... FAILED
    1. test_VIDIOC_G_SLICED_VBI_CAP.c:136  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_G_EXT_CTRLS with NULL parameter ... FAILED
    1. test_VIDIOC_EXT_CTRLS.c:325  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_S_EXT_CTRLS with NULL parameter ... FAILED
    1. test_VIDIOC_EXT_CTRLS.c:500  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_TRY_EXT_CTRLS with NULL parameter ... FAILED
    1. test_VIDIOC_EXT_CTRLS.c:675  - CU_ASSERT_EQUAL(errno_null,EINVAL)
  Test: VIDIOC_ENUM_FRAMESIZES with NULL parameter ... FAILED
    1. test_VIDIOC_ENUM_FRAMESIZES.c:585  - CU_ASSERT_EQUAL(errno_null,EINVAL)
Suite: debug ioctl calls
  Test: test_VIDIOC_LOG_STATUS ... passed
Suite: invalid ioctl calls
  Test: invalid ioctl _IO(0, 0) ... passed
  Test: invalid ioctl _IO(0xFF, 0xFF) ... passed
  Test: invalid v4l1 ioctl _IO('v', 0xFF) ... passed
  Test: invalid v4l2 ioctl _IO('V', 0xFF) ... passed

--Run Summary: Type      Total     Ran  Passed  Failed
               suites       10      10     n/a       0
               tests       177     177     144      33
               asserts    8605    8605    8351     254

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


