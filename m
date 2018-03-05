Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51791 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934156AbeCENvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 08:51:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/7] cec-core.rst: document the error injection ops
Date: Mon,  5 Mar 2018 14:51:34 +0100
Message-Id: <20180305135139.95652-3-hverkuil@xs4all.nl>
In-Reply-To: <20180305135139.95652-1-hverkuil@xs4all.nl>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new core error injection callbacks.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 72 ++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 62b9a1448177..a9f53f069a2d 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -110,11 +110,14 @@ your driver:
 		void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
 		void (*adap_free)(struct cec_adapter *adap);
 
+		/* Error injection callbacks */
+		...
+
 		/* High-level callbacks */
 		...
 	};
 
-The five low-level ops deal with various aspects of controlling the CEC adapter
+The seven low-level ops deal with various aspects of controlling the CEC adapter
 hardware:
 
 
@@ -286,6 +289,70 @@ handling the receive interrupt. The framework expects to see the cec_transmit_do
 call before the cec_received_msg call, otherwise it can get confused if the
 received message was in reply to the transmitted message.
 
+Optional: Implementing Error Injection Support
+----------------------------------------------
+
+If the CEC adapter supports Error Injection functionality, then that can
+be exposed through the Error Injection callbacks:
+
+.. code-block:: none
+
+	struct cec_adap_ops {
+		/* Low-level callbacks */
+		...
+
+		/* Error injection callbacks */
+		int (*error_inj_show)(struct cec_adapter *adap, struct seq_file *sf);
+		bool (*error_inj_parse_line)(struct cec_adapter *adap, char *line);
+
+		/* High-level CEC message callback */
+		...
+	};
+
+If both callbacks are set, then an ``error-inj`` file will appear in debugfs.
+The basic syntax is as follows:
+
+Leading spaces/tabs are ignored. If the next character is a ``#`` or the end of the
+line was reached, then the whole line is ignored. Otherwise a command is expected.
+
+This basic parsing is done in the CEC Framework. It is up to the driver to decide
+what commands to implement. The only requirement is that the command ``clear`` without
+any arguments must be implemented and that it will remove all current error injection
+commands.
+
+This ensures that you can always do ``echo clear >error-inj`` to clear any error
+injections without having to know the details of the driver-specific commands.
+
+Note that the output of ``error-inj`` shall be valid as input to ``error-inj``.
+So this must work:
+
+.. code-block:: none
+
+	$ cat error-inj >einj.txt
+	$ cat einj.txt >error-inj
+
+The first callback is called when this file is read and it should show the
+the current error injection state:
+
+.. c:function::
+	int (*error_inj_show)(struct cec_adapter *adap, struct seq_file *sf);
+
+It is recommended that it starts with a comment block with basic usage
+information. It returns 0 for success and an error otherwise.
+
+The second callback will parse commands written to the ``error-inj`` file:
+
+.. c:function::
+	bool (*error_inj_parse_line)(struct cec_adapter *adap, char *line);
+
+The ``line`` argument points to the start of the command. Any leading
+spaces or tabs have already been skipped. It is a single line only (so there
+are no embedded newlines) and it is 0-terminated. The callback is free to
+modify the contents of the buffer. It is only called for lines containing a
+command, so this callback is never called for empty lines or comment lines.
+
+Return true if the command was valid or false if there were syntax errors.
+
 Implementing the High-Level CEC Adapter
 ---------------------------------------
 
@@ -298,6 +365,9 @@ CEC protocol driven. The following high-level callbacks are available:
 		/* Low-level callbacks */
 		...
 
+		/* Error injection callbacks */
+		...
+
 		/* High-level CEC message callback */
 		int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
 	};
-- 
2.16.1
