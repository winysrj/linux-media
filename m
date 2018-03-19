Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40694 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755877AbeCSPna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:43:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/8] media-types.rst: rename media-entity-type to media-entity-functions
Date: Mon, 19 Mar 2018 16:43:24 +0100
Message-Id: <20180319154324.37799-9-hverkuil@xs4all.nl>
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The MEDIA_ENT_F_* defines refer to functions, not types. Update the
documentation accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst | 4 ++--
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    | 2 +-
 Documentation/media/uapi/mediactl/media-types.rst             | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 98d9b171a96c..6b0ab65288c6 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -89,7 +89,7 @@ id's until they get an error.
 
        -
        -
-       -  Entity type, see :ref:`media-entity-type` for details.
+       -  Entity type, see :ref:`media-entity-functions` for details.
           Deprecated. If possible, use the ``function`` field instead.
 	  For backwards compatibility this ``type`` field will only
 	  expose functions ``MEDIA_ENT_F_IO_V4L``, ``MEDIA_ENT_F_CAM_SENSOR``,
@@ -156,7 +156,7 @@ id's until they get an error.
 
        -
        -
-       -  Entity main function, see :ref:`media-entity-type` for details.
+       -  Entity main function, see :ref:`media-entity-functions` for details.
           Only valid if ``MEDIA_ENTITY_DESC_HAS_FUNCTION(media_version)``
           returns true. The ``media_version`` is defined in struct
           :c:type:`media_device_info`.
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index acc1f51ad9df..6521ab7c9b58 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -205,7 +205,7 @@ desired arrays with the media graph elements.
 
        -  ``function``
 
-       -  Entity main function, see :ref:`media-entity-type` for details.
+       -  Entity main function, see :ref:`media-entity-functions` for details.
 
     -  .. row 4
 
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index f92f10b7ffbd..2dda14bd89b7 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -7,11 +7,11 @@ Types and flags used to represent the media graph elements
 
 ..  tabularcolumns:: |p{8.2cm}|p{10.3cm}|
 
-.. _media-entity-type:
+.. _media-entity-functions:
 
 .. cssclass:: longtable
 
-.. flat-table:: Media entity types
+.. flat-table:: Media entity functions
     :header-rows:  0
     :stub-columns: 0
 
-- 
2.15.1
